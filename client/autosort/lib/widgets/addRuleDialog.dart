import 'package:autosort/theme.dart';
import 'package:autosort/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddRuleDialog extends StatefulWidget {
  final Function(String category, List<String> extensions) onSave;
  final String? initialCategory;
  final List<String>? initialExtensions;

  const AddRuleDialog({
    required this.onSave,
    this.initialCategory,
    this.initialExtensions,
    super.key,
  });

  @override
  State<AddRuleDialog> createState() => _AddRuleDialogState();
}

class _AddRuleDialogState extends State<AddRuleDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryController;
  late TextEditingController _extensionsController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.initialCategory);
    _extensionsController = TextEditingController(
      text: widget.initialExtensions?.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _extensionsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final category = _categoryController.text.trim();
      final extensions = _extensionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      widget.onSave(category, extensions);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints.tight(Size(400, 300)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      title: Text(
        "Add New Rule",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: "Category",
                labelStyle: TextStyle(color: AppColors.secondaryText),
                hintText: "e.g. Documents",
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter a category" : null,
            ),
            const SizedBox(height: 10),

            // Extensions input
            TextFormField(
              controller: _extensionsController,
              decoration: InputDecoration(
                labelText: "Extensions",
                labelStyle: TextStyle(color: AppColors.secondaryText),
                hintText: "e.g. .pdf, .docx, .txt",
              ),
              validator: (value) => value == null || value.isEmpty
                  ? "Enter at least one extension"
                  : null,
            ),
          ],
        ),
      ),

      actions: [
        CustomButton(
          text: 'Cancel',
          textColor: AppColors.buttonText,
          hoverColor: AppColors.buttonHover,
          onPressed: () => {Navigator.pop(context)},
        ),

        CustomButton(
          text: 'Save',
          onPressed: _handleSave,
          backgroundColor: AppColors.buttonBackground,
          textColor: AppColors.buttonText,
          hoverColor: AppColors.buttonHover,
        ),
        // ElevatedButton(
        //   onPressed: _handleSave,
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: AppColors.primaryText,
        //     foregroundColor: Colors.white,
        //   ),

        //   child: const Text("Save"),
        // ),
      ],
    );
  }
}
