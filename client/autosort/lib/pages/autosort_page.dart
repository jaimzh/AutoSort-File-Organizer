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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
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
            Text(
              'Automatically organize your files with just a few clicks',
              style: TextStyle(
                fontSize: AppFontSizes.kBodyText,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: const FileConfigCard(title: 'Folder Configuration'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const ScanCard(),
                const SizedBox(width: 20),
                const MonitorCard(),
              ],
            ),
          ],
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
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.folderOpen, color: AppColors.primaryText),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.kBodyText,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Select what folder to automatically Sort and where to send the sorted files to.',
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
                  Text(
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
                  Text(
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
                  Divider(thickness: 1, color: AppColors.divider),
                  Text(
                    'Transfer Mode',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const ModeToggle(initialValue: true),
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
  final Color? buttonColor;
  final Color? hoverButtonColor;

  const ButtonCard({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    this.buttonText = "HEHEHE",
    this.onPressed,
    this.buttonColor,
    this.hoverButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(2, 2),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: AppFontSizes.kSidebarItem,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(
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
            backgroundColor: buttonColor ?? AppColors.buttonBackground,
            textColor: AppColors.buttonText,
            hoverColor: hoverButtonColor ?? AppColors.buttonHover,
            onPressed: onPressed ?? () {},
          ),
        ],
      ),
    );
  }
}
