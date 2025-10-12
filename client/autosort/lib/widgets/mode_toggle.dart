import 'package:autosort/constants.dart';
import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:flutter/material.dart';

class ModeToggle extends StatefulWidget {
  final bool initialValue;

  const ModeToggle({
    super.key,
    this.initialValue = true, // default = Safe mode
  });

  @override
  State<ModeToggle> createState() => _ModeToggleState();
}

class _ModeToggleState extends State<ModeToggle> {
  late bool _isSafeMode;

  @override
  void initState() {
    super.initState();
    _isSafeMode = widget.initialValue;
  }

  Future<void> _toggleMode(bool value) async {
    setState(() {
      _isSafeMode = value;
    });
    try {
      await ApiService.updateConfig(mode: _isSafeMode ? "safe" : "fast");
      print("✅ Mode updated to ${_isSafeMode ? "Safe" : "Fast"}");
    } catch (e) {
      print("❌ Error updating mode: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dynamic text message
        Expanded(
          child: Text(
            _isSafeMode
                ? 'Safe mode with extra verification'
                : 'Fast mode for quick processing',
            style: const TextStyle(
              fontSize: AppFontSizes.kBodyText,
              color: AppColors.secondaryText,
            ),
          ),
        ),

        // Safe icon
        Icon(Icons.security, color: _isSafeMode ? Colors.green : Colors.grey),
        SizedBox(width: 2),
        Text(
          "Safe",
          style: TextStyle(
            fontSize: AppFontSizes.kBodyText,
            color: _isSafeMode ? Colors.green : AppColors.secondaryText,
            // fontWeight: _isSafeMode ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        const SizedBox(width: 6),

        // Toggle switch
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: _isSafeMode,
            onChanged: _toggleMode,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),

            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.amber,
            thumbColor: WidgetStateProperty.all(Colors.white),
          ),
        ),

        const SizedBox(width: 6),

        Text(
          "Fast",
          style: TextStyle(
            fontSize: AppFontSizes.kBodyText,
            color: !_isSafeMode ? Colors.amber : AppColors.secondaryText,
            // fontWeight: !_isSafeMode ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        SizedBox(width: 2),
        // Fast icon
        Icon(
          Icons.flash_on,
          color: !_isSafeMode
              ? Colors.amber
              : const Color.fromARGB(255, 158, 158, 158),
        ),
      ],
    );
  }
}
