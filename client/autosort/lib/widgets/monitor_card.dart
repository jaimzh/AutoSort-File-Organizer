import 'package:autosort/pages/autosort_page.dart';
import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MonitorCard extends StatefulWidget {
  const MonitorCard({super.key});

  @override
  State<MonitorCard> createState() => _MonitorCardState();
}

class _MonitorCardState extends State<MonitorCard> {
  void toggleMonitoring() async {
    if (ApiService.isMonitoring) {
      await ApiService.stopMonitor();
    } else {
      await ApiService.startMonitor();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMonitoring = ApiService.isMonitoring;
    return Expanded(
      child: ButtonCard(
        title: 'Live Monitoring',
        text: 'Continuously watch and sort files.',
        icon: LucideIcons.eye,
        buttonText: isMonitoring ? "Stop Monitoring" : "Start Monitoring",
        buttonColor: isMonitoring ? Colors.red : AppColors.buttonBackground,
        hoverButtonColor: isMonitoring
            ? const Color.fromARGB(255, 255, 82, 70)
            : AppColors.buttonHover,
        onPressed: toggleMonitoring,
      ),
    );
  }
}
