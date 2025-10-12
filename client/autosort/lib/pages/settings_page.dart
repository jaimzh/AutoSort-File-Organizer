import 'dart:convert';
import 'package:autosort/constants.dart';
import 'package:autosort/providers/theme_provider.dart';
import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:highlight/languages/json.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

Future<void> openConfigEditor(
  BuildContext context,
  Map<String, dynamic> config,
  Function(Map<String, dynamic>) onSave,
) async {
  final controller = CodeController(
    text: const JsonEncoder.withIndent('  ').convert(config),
    language: json,
  );

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: 500,
        height: 400,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Configuration',
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    size: 22,
                    color: Colors.white,
                  ),
                  tooltip: "Reset Config",
                  onPressed: () async {
                    // Call the reset defaults API
                    final resetConfig = await ApiService.resetDefaults();
                    if (resetConfig != null) {
                      // Update the controller text
                      controller.text = const JsonEncoder.withIndent(
                        '  ',
                      ).convert(resetConfig);

                      // Call the callback to update SettingsPage
                      onSave(resetConfig);

                      // Optional: show feedback
                      if (dialogContext.mounted) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text("✅ Configuration reset to defaults"),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CodeTheme(
                data: CodeThemeData(styles: vs2015Theme),
                child: SingleChildScrollView(
                  child: CodeField(
                    controller: controller,
                    textStyle: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.pop(dialogContext),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            try {
              final updated = jsonDecode(controller.text);

              final response = await ApiService.updateFullConfig(updated);

              if (!dialogContext.mounted) return;

              if (response != null) {
                onSave(updated);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Configuration updated successfully!"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text("❌ Failed to update config on backend"),
                  ),
                );
              }
            } catch (e) {
              if (!dialogContext.mounted) return;
              ScaffoldMessenger.of(dialogContext).showSnackBar(
                const SnackBar(content: Text("Invalid JSON format")),
              );
            }
          },
        ),
      ],
    ),
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<Map<String, dynamic>?> _configFuture;

  @override
  void initState() {
    super.initState();
    _configFuture = ApiService.getConfig();
  }

  void _handleConfigUpdate(Map<String, dynamic> updatedConfig) {
    setState(() {
      // Wrap in Future.value so it matches type
      _configFuture = Future.value(updatedConfig);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _configFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error loading config: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No config data found"));
        }

        final config = snapshot.data!;

        return Container(
          color: AppColors.pageBackground,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: AppFontSizes.kPageTitle,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.code, size: 22),
                    tooltip: "Edit Config",
                    onPressed: () =>
                        openConfigEditor(context, config, _handleConfigUpdate),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildCard(
                "File Processing",
                "Processing details will appear here.",
              ),
              const SizedBox(height: 20),
              _buildCard("Another Section", "Additional configuration info."),

              ThemeSwitch(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.scroll, color: AppColors.primaryText),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.kBodyText,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, ThemeProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dark Mode'),
            Switch(
              value: false,
              onChanged: (value) {
                // placeholder: do nothing for now
              },
            ),
          ],
        );
      },
    );
  }
}
