import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Dashboard chart for "Files Sorted"
class FilesSortedChart extends StatefulWidget {
  const FilesSortedChart({super.key});

  @override
  State<FilesSortedChart> createState() => _FilesSortedChartState();
}

class _FilesSortedChartState extends State<FilesSortedChart> {
  late TooltipBehavior _tooltipBehavior;
  List<_ChartData> _chartData = [];
  bool _isLoading = true;
  bool _isEmpty = false;
  int _explodeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final counts = await ApiService.getCounts();

    if (!mounted) return;

    if (counts == null) {
      // if API failed, you can still show empty state
      setState(() {
        _isLoading = false;
        _isEmpty = true;
      });
      return;
    }

    // check if literally everything is 0 like in your sample
    final allZero = counts.values.every((v) => (v ?? 0) == 0);

    // build chart data from non-zero items (excluding "Total")
    final data = counts.entries
        .where((e) => e.key.toLowerCase() != 'total' && (e.value ?? 0) > 0)
        .map(
          (e) =>
              _ChartData(e.key, (e.value ?? 0).toDouble(), e.value.toString()),
        )
        .toList();

    setState(() {
      _isLoading = false;
      _chartData = data;
      _isEmpty = allZero || data.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isEmpty) {
      // your "replace entire chart with emoji or something" part
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.chartPie,
              size: 60,
              color: AppColors.iconBackground,
            ),

            const SizedBox(height: 12),
            Text(
              'No files sorted yet',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Run a sort so I can actually draw a chart.',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SfCircularChart(
      palette: AppColors.chartPalette,
      legend: Legend(
        position: LegendPosition.bottom,
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle: TextStyle(color: AppColors.primaryText),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <DoughnutSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          radius: '80%',
          innerRadius: '30%',
          dataSource: _chartData,
          xValueMapper: (_ChartData data, _) => data.label,
          yValueMapper: (_ChartData data, _) => data.value,
          dataLabelMapper: (_ChartData data, _) => data.text,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryText,
            ),
            connectorLineSettings: const ConnectorLineSettings(),
          ),
          explode: true,
          explodeIndex: _explodeIndex,
          onPointTap: (ChartPointDetails details) {
            setState(() {
              _explodeIndex = details.pointIndex!;
            });
          },
          animationDuration: 1000,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

/// Chart data class
class _ChartData {
  final String label;
  final double value;
  final String text;
  _ChartData(this.label, this.value, this.text);
}
