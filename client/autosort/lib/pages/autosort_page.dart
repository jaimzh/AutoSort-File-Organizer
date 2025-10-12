import 'package:autosort/constants.dart';
import 'package:autosort/theme.dart';
import 'package:autosort/widgets/custom_button.dart';
import 'package:autosort/widgets/file_selector_widget.dart';
import 'package:autosort/widgets/mode_toggle.dart';
import 'package:autosort/widgets/monitor_card.dart';
import 'package:autosort/widgets/sort_now_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AutosortPage extends StatelessWidget {
  const AutosortPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      height: double.infinity,

      padding: const EdgeInsets.all(20),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'AutoSort',
                    style: TextStyle(
                      fontSize: AppFontSizes.kPageTitle,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Automatically organize your files with just a few clicks',
                style: TextStyle(
                  fontSize: AppFontSizes.kBodyText,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 400,
                child: FileConfigCard(title: 'Folder Configuration'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ScanCard(),
                  const SizedBox(width: 20),
                  MonitorCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileConfigCard extends StatelessWidget {
  final String title;

  const FileConfigCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
              const Icon(LucideIcons.folderOpen, color: AppColors.primaryText),
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
          const Text(
            'Choose the folders where AutoSort will work',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: AppFontSizes.kBodyText,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Source Folder',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const FolderPickerWidget(isSource: true),
                  const SizedBox(height: 20),
                  const Text(
                    'Destination Folder',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const FolderPickerWidget(
                    subFolderName: 'AutoSorted',
                    isSource: false,
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: AppColors.divider),
                  const Text(
                    'Transfer Mode',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ModeToggle(initialValue: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color buttonColor;
  final Color hoverButtonColor;

  const ButtonCard({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    this.buttonText = "HEHEHE",
    this.onPressed,
    this.buttonColor = AppColors.buttonBackground,
    this.hoverButtonColor = const Color.fromARGB(255, 71, 255, 9),
  });

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.iconBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.transparent, width: 2),
                ),
                child: Icon(icon, color: AppColors.iconColor, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: AppFontSizes.kSidebarItem, // ✅ used here
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: AppFontSizes.kBodyText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: buttonText,
            enableFlex: true,
            backgroundColor: buttonColor,
            textColor: AppColors.buttonText,
            hoverColor: hoverButtonColor,
            onPressed: onPressed ?? () {},
          ),
        ],
      ),
    );
  }
}
