import 'package:autosort/theme.dart';
import 'package:autosort/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddExceptionDialog extends StatefulWidget {
  final Function(List<String> extensions) onSave;

  final List<String>? initialExtensions;

  const AddExceptionDialog({
    required this.onSave,

    this.initialExtensions,
    super.key,
  });

  @override
  State<AddExceptionDialog> createState() => _AddExceptionDialogState();
}

class _AddExceptionDialogState extends State<AddExceptionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _extensionsController;

  @override
  void initState() {
    super.initState();

    _extensionsController = TextEditingController(
      text: widget.initialExtensions?.join(', ') ?? '',
    );

    // _extensionsController.selection = TextSelection.fromPosition(
    //   TextPosition(offset: _extensionsController.text.length),
    // );
  }

  @override
  void dispose() {
    _extensionsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final extensions = _extensionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      widget.onSave(extensions);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      constraints: BoxConstraints.tight(Size(500, 230)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      title: Text(
        "Add New Exception",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          controller: _extensionsController,
          decoration: const InputDecoration(
            labelText: "Exceptions",
            hintText: "e.g. .tmp, .crd, .zip",
          ),
          validator: (value) => value == null || value.isEmpty
              ? "Enter at least one extension"
              : null,
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
      ],
    );
  }
}
