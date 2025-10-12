import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/json.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late CodeController _codeController;

  Map<String, dynamic> config = {
    "api_url": "http://127.0.0.1:8001",
    "auto_sort_enabled": true,
    "rules": {
      "images": [".png", ".jpg"],
      "documents": [".pdf", ".docx"],
    },
    "exceptions": [],
  };

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: const JsonEncoder.withIndent('  ').convert(config),
      language: json,
      
    );
  }

  void _openConfigEditor(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Edit Configuration',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: 500,
          height: 400,
          child: CodeField(
            controller: _codeController,
            textStyle: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              try {
                final updated = jsonDecode(_codeController.text);
                setState(() => config = updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Configuration updated")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid JSON format")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit),
        label: const Text("Open Config Editor"),
        onPressed: () => _openConfigEditor(context),
      ),
    );
  }
}
