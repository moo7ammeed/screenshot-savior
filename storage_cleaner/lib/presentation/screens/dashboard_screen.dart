import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

// Auto-scan on load
final scanProvider = FutureProvider.autoDispose<StorageSummary>((ref) async {
  return ref.read(storageServiceProvider).scanStorage();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(scanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Analyzer"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: asyncData.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircularProgressIndicator(),
               SizedBox(height: 10),
               Text("Scanning Storage... This may take a moment")
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Error: $err\n\nMake sure to grant permissions.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Chart
              Container(
                height: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),
                child: StoragePieChart(data: summary.categorySizes),
              ),
              const SizedBox(height: 20),

              // 2. Junk Section
              _buildJunkCard(context, summary, ref),
              const SizedBox(height: 20),

              // 3. Large Files
              const Text("Big Files (>50MB)", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 10),
              
              if(summary.largeFiles.isEmpty)
                const Text("No large files found."),

              ...summary.largeFiles.take(10).map((file) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: Colors.amber),
                  title: Text(
                    file.path.split('/').last, 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis
                  ),
                  subtitle: Text(_formatBytes(file.size)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ref.read(storageServiceProvider).deleteFile(file.path);
                      // Trigger refresh
                      ref.invalidate(scanProvider);
                    },
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => ref.invalidate(scanProvider),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildJunkCard(BuildContext context, StorageSummary summary, WidgetRef ref) {
    int junkSize = summary.categorySizes['Junk'] ?? 0;
    return Card(
      color: Colors.red.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.delete_sweep, color: Colors.white),
        ),
        title: const Text("Junk Files", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${_formatBytes(junkSize)} detected"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, 
            foregroundColor: Colors.white
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Deleting junk in background..."))
            );
            // Simple loop to delete junk
            for (var file in summary.junkFiles) {
               ref.read(storageServiceProvider).deleteFile(file.path);
            }
            ref.invalidate(scanProvider);
          },
          child: const Text("CLEAN"),
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}

class StoragePieChart extends StatelessWidget {
  final Map<String, int> data;
  const StoragePieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.blue, Colors.green, Colors.orange, 
      Colors.purple, Colors.red, Colors.grey, Colors.teal
    ];
    int i = 0;
    
    // Filter out zero values for better chart
    final validData = data.entries.where((e) => e.value > 0).toList();

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: validData.map((e) {
          final color = colors[i++ % colors.length];
          return PieChartSectionData(
            color: color,
            value: e.value.toDouble(),
            title: '', 
            radius: 50,
            badgeWidget: _Badge(e.key, color),
            badgePositionPercentageOffset: 1.4,
          );
        }).toList(),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white, 
        border: Border.all(color: color), 
        borderRadius: BorderRadius.circular(5),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 2)]
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
