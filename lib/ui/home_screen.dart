import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:drift/drift.dart' as drift; 
import '../providers/providers.dart';
import '../data/database.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isScanning = false;

  Future<void> _scanImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('نحتاج صلاحية الصور للعمل!')));
      return;
    }

    setState(() => _isScanning = true);
    
    try {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albums.isEmpty) return;
      
      final recentAlbum = albums.first;
      final List<AssetEntity> images = await recentAlbum.getAssetListRange(start: 0, end: 50);

      final db = ref.read(databaseProvider);
      final ocr = ref.read(ocrServiceProvider);
      int count = 0;
      int skipped = 0;

      for (var image in images) {
        final File? file = await image.file;
        if (file == null) continue;

        final extractedText = await ocr.extractTextFromImage(file);

        if (extractedText.trim().isNotEmpty) {
          try {
            await db.insertScreenshot(ScreenshotsCompanion(
              path: drift.Value(file.path),
              extractedText: drift.Value(extractedText),
            ));
            count++;
          } catch (e) {
            skipped++;
          }
        }
      }

      ref.refresh(screenshotsListProvider);
      
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('تمت الإضافة: $count | مكرر: $skipped ✅'),
          backgroundColor: count > 0 ? Colors.green : Colors.grey,
        ));
      }

    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenshotsAsync = ref.watch(screenshotsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Screenshot Savior 🕵️‍♂️')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث... (مثال: فاتورة، كود)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: screenshotsAsync.when(
              data: (screenshots) => screenshots.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history, size: 64, color: Colors.grey),
                          const SizedBox(height: 10),
                          const Text("اضغط الزر بالأسفل لفحص الصور"),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: screenshots.length,
                      itemBuilder: (context, index) {
                        final item = screenshots[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                                showDialog(
                                  context: context, 
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("النص المستخرج"),
                                    content: SingleChildScrollView(
                                      child: SelectableText(item.extractedText),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: item.extractedText));
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم النسخ!"), duration: Duration(milliseconds: 500)));
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text("نسخ"),
                                      ),
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إغلاق"))
                                    ],
                                  )
                                );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.file(
                                    File(item.path),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_,__,___) => const Center(child: Icon(Icons.broken_image)),
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    item.extractedText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isScanning ? null : _scanImages,
        icon: _isScanning 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
            : const Icon(Icons.auto_awesome),
        label: Text(_isScanning ? 'جاري التحليل...' : 'فحص المعرض'),
      ),
    );
  }
}
