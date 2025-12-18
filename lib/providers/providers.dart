import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../services/ocr_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final ocrServiceProvider = Provider<OcrService>((ref) => OcrService());

final searchQueryProvider = StateProvider<String>((ref) => '');

final screenshotsListProvider = FutureProvider<List<Screenshot>>((ref) async {
  final db = ref.watch(databaseProvider);
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return db.select(db.screenshots).get();
  } else {
    return db.searchScreenshots(query);
  }
});
