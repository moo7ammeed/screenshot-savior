import 'dart:io';
import 'dart:isolate';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class FileInfo {
  final String path;
  final int size;
  final String category;
  FileInfo({required this.path, required this.size, required this.category});
}

class StorageSummary {
  final int usedSpace;
  final List<FileInfo> junkFiles;
  final List<FileInfo> largeFiles;
  final Map<String, int> categorySizes;

  StorageSummary({
    required this.usedSpace,
    required this.junkFiles,
    required this.largeFiles,
    required this.categorySizes,
  });
}

class StorageService {
  Future<bool> requestPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    // Android 11 (API 30) and above
    if (androidInfo.version.sdkInt >= 30) {
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      // Android 10 and below
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<StorageSummary> scanStorage() async {
    bool granted = await requestPermission();
    if (!granted) throw Exception("Permission Denied. Please enable storage access.");
    
    // Run scan in background Isolate
    return await Isolate.run(_scanLogic);
  }

  static Future<StorageSummary> _scanLogic() async {
    final rootDir = Directory('/storage/emulated/0');
    
    List<FileInfo> junkFiles = [];
    List<FileInfo> largeFiles = [];
    Map<String, int> categorySizes = {
      'Images': 0, 'Videos': 0, 'Audio': 0, 'Docs': 0, 'APK': 0, 'Junk': 0, 'Others': 0
    };
    int totalUsed = 0;

    void scan(Directory dir) {
      try {
        final entities = dir.listSync(recursive: false, followLinks: false);
        for (var entity in entities) {
          if (entity is Directory) {
            // Skip hidden folders (starting with .) and typical restricted android folders
            if (!entity.path.split('/').last.startsWith('.')) {
              scan(entity);
            }
          } else if (entity is File) {
            try {
              final size = entity.statSync().size;
              final ext = entity.path.split('.').last.toLowerCase();
              String cat = 'Others';

              if (['jpg', 'png', 'jpeg', 'gif'].contains(ext)) cat = 'Images';
              else if (['mp4', 'mkv', 'avi', 'mov'].contains(ext)) cat = 'Videos';
              else if (['mp3', 'wav', 'aac', 'm4a'].contains(ext)) cat = 'Audio';
              else if (['pdf', 'doc', 'docx', 'txt'].contains(ext)) cat = 'Docs';
              else if (ext == 'apk') cat = 'APK';
              else if (['tmp', 'log', 'cache', 'chk'].contains(ext)) cat = 'Junk';

              categorySizes[cat] = (categorySizes[cat] ?? 0) + size;
              totalUsed += size;

              final info = FileInfo(path: entity.path, size: size, category: cat);
              if (cat == 'Junk') junkFiles.add(info);
              // Large files > 50MB
              if (size > 50 * 1024 * 1024) largeFiles.add(info);
            } catch (e) {
               // Skip files we can't read
            }
          }
        }
      } catch (e) {
        // Access denied to folder
      }
    }

    scan(rootDir);
    
    // Sort large files descending
    largeFiles.sort((a, b) => b.size.compareTo(a.size));

    return StorageSummary(
      usedSpace: totalUsed,
      junkFiles: junkFiles,
      largeFiles: largeFiles,
      categorySizes: categorySizes,
    );
  }
  
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
