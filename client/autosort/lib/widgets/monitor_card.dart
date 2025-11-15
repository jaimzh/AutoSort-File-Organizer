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
    final wasMonitoring = ApiService.isMonitoring;

    if (wasMonitoring) {
      await ApiService.stopMonitor();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Live Monitoring stopped.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      await ApiService.startMonitor();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Live Monitoring started.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryBackground, // AutoSort theme
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
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
