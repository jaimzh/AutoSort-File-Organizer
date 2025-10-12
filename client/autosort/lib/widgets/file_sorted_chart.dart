import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Dashboard chart for "Files Sorted"
class FilesSortedChart extends StatefulWidget {
  const FilesSortedChart({super.key});

  @override
  State<FilesSortedChart> createState() => _FilesSortedChartState();
}

class _FilesSortedChartState extends State<FilesSortedChart> {
  late List<_ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  int _explodeIndex = 0;

  @override
  void initState() {
    super.initState();

    _chartData = [];

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
    );

    _loadCounts();
  }

  void _loadCounts() async {
    final counts = await ApiService.getCounts();
    if (counts != null) {
      setState(() {
        _chartData = counts.entries
            .where(
              (e) =>
                  e.key.toLowerCase() != "total" && // ✅ skip "Total"
                  (e.value ?? 0) > 0,
            )
            .map(
              (e) => _ChartData(
                e.key,
                (e.value ?? 0).toDouble(),
                e.value.toString(),
              ),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      palette: AppColors.chartPalette,
      legend: Legend(
        position: LegendPosition.bottom,
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <DoughnutSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          radius: '90%', // make chart fill more of its container
          innerRadius: '40%',
          dataSource: _chartData,
          xValueMapper: (_ChartData data, _) => data.label,
          yValueMapper: (_ChartData data, _) => data.value,
          dataLabelMapper: (_ChartData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
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
