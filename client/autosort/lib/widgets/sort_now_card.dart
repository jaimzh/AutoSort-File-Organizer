import 'package:autosort/pages/autosort_page.dart';
import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScanCard extends StatefulWidget {
  const ScanCard({super.key});

  @override
  State<ScanCard> createState() => _ScanCardState();
}

class _ScanCardState extends State<ScanCard> {
  bool isScanning = false;
  bool isScanComplete = false;

  void toggleScanning() async {
    if (!isScanning) {
      setState(() {
        isScanning = true;
      });

      try {
        await ApiService.startScan();
      } finally {
        if (mounted) {
          setState(() {
            isScanning = false;
            isScanComplete = true;
          });
        }
      }
    } else {
      ApiService.stopScan();
      setState(() {
        isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonCard(
        title: 'One-Time Sort',
        text: 'Instantly scan and organize files.',
        icon: LucideIcons.sparkles,

        buttonText: isScanning ? "Stop Scan" : "Scan Now",
        buttonColor: isScanning ? Colors.red : AppColors.buttonBackground,
        hoverButtonColor: isScanning
            ? const Color.fromARGB(255, 255, 82, 70)
            : AppColors.buttonHover,
        onPressed: toggleScanning,
      ),
    );
  }
}
