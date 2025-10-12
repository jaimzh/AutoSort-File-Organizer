import 'package:autosort/services/api_service.dart';
import 'package:flutter/material.dart';


class TestApiWidget extends StatefulWidget {
  const TestApiWidget({super.key});

  @override
  State<TestApiWidget> createState() => _TestApiWidgetState();
}

class _TestApiWidgetState extends State<TestApiWidget> {
  String output = "Press a button to test API";

  void _setOutput(String msg) {
    setState(() {
      output = msg;
    });
  }

  Future<void> _getConfig() async {
    final config = await ApiService.getConfig();
    _setOutput("Config: $config");
  }

  Future<void> _updateConfig() async {
    final updated = await ApiService.updateConfig(mode: "fast");
    _setOutput("Updated config: $updated");
  }

  Future<void> _startScan() async {
    await ApiService.startScan();
    _setOutput("Started Scan");
  }

  Future<void> _stopScan() async {
    await ApiService.stopScan();
    _setOutput("Stopped Scan");
  }

  Future<void> _startMonitor() async {
    await ApiService.startMonitor();
    _setOutput("Started Monitor");
  }

  Future<void> _stopMonitor() async {
    await ApiService.stopMonitor();
    _setOutput("Stopped Monitor");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test API 🚀")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(onPressed: _getConfig, child: const Text("Get Config")),
            ElevatedButton(onPressed: _updateConfig, child: const Text("Update Config")),
            ElevatedButton(onPressed: _startScan, child: const Text("Start Scan")),
            ElevatedButton(onPressed: _stopScan, child: const Text("Stop Scan")),
            ElevatedButton(onPressed: _startMonitor, child: const Text("Start Monitor")),
            ElevatedButton(onPressed: _stopMonitor, child: const Text("Stop Monitor")),
            const SizedBox(height: 20),
            Text(
              output,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
