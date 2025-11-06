import 'dart:io';
import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:autosort/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';

class FolderPickerWidget extends StatefulWidget {
  final String subFolderName;
  final bool isSource;

  const FolderPickerWidget({
    super.key,
    this.subFolderName = '',
    this.isSource = true,
  });

  @override
  State<FolderPickerWidget> createState() => _FolderPickerWidgetState();
}

class _FolderPickerWidgetState extends State<FolderPickerWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _setDefaultFolder();

    _loadFolder();
  }

  Future<void> _loadFolder() async {
    try {
      final config = await ApiService.getConfig();

      final savedPath = (config != null)
          ? (widget.isSource
                ? config["source_folder"]
                : config["destination_folder"])
          : null;

      if (savedPath != null && savedPath.toString().isNotEmpty) {
        setState(() {
          _controller.text = savedPath.toString();
        });
      } else {
        await _setDefaultFolder(); // fallback
      }
    } catch (e) {
      debugPrint("❌ Failed to load config: $e");
      await _setDefaultFolder();
    }
  }

  Future<void> _setDefaultFolder() async {
    try {
      final downloadsDir = await getDownloadsDirectory();

      if (downloadsDir != null) {
        // Build the final absolute path
        final String finalPath = widget.subFolderName.isNotEmpty
            ? "${downloadsDir.path}/${widget.subFolderName}"
            : downloadsDir.path;

        final dir = Directory(finalPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        setState(() {
          _controller.text = dir.path; // ✅ Always full absolute path
        });
      } else {
        // Fallback if downloadsDir is null
        setState(() {
          _controller.text = widget.subFolderName.isNotEmpty
              ? "C:/Users/Default/Downloads/${widget.subFolderName}"
              : "C:/Users/Default/Downloads";
        });
      }
    } catch (e) {
      debugPrint("Failed to get default folder: $e");
      setState(() {
        _controller.text = widget.subFolderName.isNotEmpty
            ? "C:/Users/Default/Downloads/${widget.subFolderName}"
            : "C:/Users/Default/Downloads";
      });
    }
  }

  Future<void> _pickFolder() async {
    final String? path = await getDirectoryPath();
    if (path != null) {
      setState(() {
        _controller.text = path;
      });

      // 🔥 Patch the backend config
      final result = await ApiService.updateConfig(
        sourceFolder: widget.isSource ? path : null,
        destinationFolder: widget.isSource ? null : path,
      );

      if (result != null) {
        debugPrint("✅ Config updated: $result");
      } else {
        debugPrint("❌ Failed to update config");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onTap: _pickFolder,
            readOnly: true,
            style: TextStyle(fontSize: 14, color: AppColors.primaryText),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              filled: true,
              fillColor: AppColors.primaryBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        CustomButton(
          text: "Browse",
          onPressed: _pickFolder,
          backgroundColor: AppColors.cardBackground,
          hoverColor: AppColors.cardHover,
          textColor: AppColors.primaryText,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
