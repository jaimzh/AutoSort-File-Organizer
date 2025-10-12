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
      // ✅ Start scanning
      setState(() {
        isScanning = true;
      });

      try {
        await ApiService.startScan(); // wait until scan is done
      } finally {
        // ✅ Reset when done
        if (mounted) {
          setState(() {
            isScanning = false;
            isScanComplete = true;
          });
        }
      }
    } else {
      // ✅ Stop scan manually
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
        title: 'Sort Now',
        text: 'Sort all the files in the source folder.',
        icon: LucideIcons.flame,

        buttonText: isScanning ? "Stop Scan" : "Scan Now",
        buttonColor: isScanning ? Colors.red : AppColors.buttonBackground,
        hoverButtonColor: isScanning
            ? const Color.fromARGB(255, 255, 82, 70)
            : const Color.fromARGB(255, 30, 30, 30),
        onPressed: toggleScanning,
      ),
    );
  }
}
