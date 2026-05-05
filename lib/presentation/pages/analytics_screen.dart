import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/presentation/providers/book_presentation_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBooks = ref.watch(filteredBooksProvider);

    if (allBooks.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Аналитика'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                'Недостаточно данных',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Добавьте книги для просмотра аналитики',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final stats = _calculateStats(allBooks);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статистика
            _buildStatsCards(context, stats),
            const SizedBox(height: 24),

            // Графики
            Text(
              'Распределение статусов',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildPieChart(context, stats),
            const SizedBox(height: 32),

            Text(
              'Процент книг по статусам',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildBarChart(context, stats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Всего',
            stats['total'].toString(),
            Icons.library_books,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Прочитано',
            stats['read'].toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, dynamic> stats) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
    ];

    final pieSections = [
      PieChartSectionData(
        value: (stats['available'] as int).toDouble(),
        title: 'Доступно\n${stats['available']}',
        color: colors[0],
        radius: 80,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      PieChartSectionData(
        value: (stats['borrowed'] as int).toDouble(),
        title: 'Выдано\n${stats['borrowed']}',
        color: colors[1],
        radius: 80,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      PieChartSectionData(
        value: (stats['reserved'] as int).toDouble(),
        title: 'Зарезервировано\n${stats['reserved']}',
        color: colors[2],
        radius: 80,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      PieChartSectionData(
        value: (stats['unavailable'] as int).toDouble(),
        title: 'Недоступно\n${stats['unavailable']}',
        color: colors[3],
        radius: 80,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ];

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: pieSections.where((s) => s.value > 0).toList(),
          centerSpaceRadius: 0,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, Map<String, dynamic> stats) {
    final total = stats['total'] as int;

    final barGroups = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: (stats['available'] as int) / total * 100,
            color: Colors.green,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: (stats['borrowed'] as int) / total * 100,
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: (stats['reserved'] as int) / total * 100,
            color: Colors.orange,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: (stats['unavailable'] as int) / total * 100,
            color: Colors.red,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              maxY: 100,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = ['Доступно', 'Выдано', 'Зарезервировано', 'Недоступно'];
                      if (value.toInt() < labels.length) {
                        return Text(
                          labels[value.toInt()],
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateStats(List<Book> books) {
    int available = 0;
    int borrowed = 0;
    int reserved = 0;
    int unavailable = 0;
    int read = 0;

    for (final book in books) {
      switch (book.status) {
        case BookStatus.available:
          available++;
          break;
        case BookStatus.borrowed:
          borrowed++;
          read++;
          break;
        case BookStatus.reserved:
          reserved++;
          break;
        case BookStatus.unavailable:
          unavailable++;
          break;
      }
    }

    return {
      'total': books.length,
      'available': available,
      'borrowed': borrowed,
      'reserved': reserved,
      'unavailable': unavailable,
      'read': read,
    };
  }
}
