import 'package:autosort/constants.dart';
import 'package:autosort/theme.dart';
import 'package:autosort/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AboutSection(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Key Features Section
                  KeyFeatures(),

                  const SizedBox(height: 20),

                  // Links & Support Section
                  LinksAndSupport(),

                  const SizedBox(height: 20),

                  Copyright(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Copyright extends StatelessWidget {
  const Copyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2025 AutoSort. Made by Jaimz🦖',
      style: TextStyle(
        fontSize: AppFontSizes.kBodyText,
        color: AppColors.secondaryText,
      ),
    );
  }
}

class LinksAndSupport extends StatelessWidget {
  const LinksAndSupport({super.key});

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
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Links & Support',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              CustomButton(
                text: 'View on GitHub',

                icon: LucideIcons.github,
                backgroundColor: Colors.transparent,
                textColor: AppColors.primaryText,
                hoverColor: const Color.fromARGB(19, 215, 215, 215),

                onPressed: () async {
                  final Uri url = Uri.parse(
                    'https://github.com/jaimzh/AutoSort-File-Organizer',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              CustomButton(
                text: 'Website',
                icon: LucideIcons.externalLink,
                backgroundColor: Colors.transparent,
                textColor: AppColors.primaryText,
                hoverColor: const Color.fromARGB(19, 215, 215, 215),

                onPressed: () async {},
              ),
              CustomButton(
                text: 'Contact Support',
                icon: LucideIcons.mail,
                backgroundColor: Colors.transparent,
                textColor: AppColors.primaryText,
                hoverColor: const Color.fromARGB(19, 215, 215, 215),

                onPressed: () async {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KeyFeatures extends StatelessWidget {
  const KeyFeatures({super.key});

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
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Key Features',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            childAspectRatio: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: const [
              FeatureTitle(
                title: 'Smart Sorting',
                info:
                    'Automatically categorizes files into Documents, Images, Videos, Audio, Archives, and more.',
              ),
              FeatureTitle(
                title: 'Custom Rules',
                info:
                    'Create and manage custom file type rules for personalized organization.',
              ),
              FeatureTitle(
                title: 'Safe Move',
                info:
                    'Copy files instead of moving them to preserve originals during organization.',
              ),
              FeatureTitle(
                title: 'Real-time Monitor',
                info:
                    'Track all file operations with detailed logs and real-time monitoring.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          const ImageVersion(),
          const SizedBox(height: 20),
          Text(
            'AutoSort is a file organizer that automatically sorts your downloads into categories.',
            style: TextStyle(
              fontSize: AppFontSizes.kBodyText,
              color: const Color.fromARGB(255, 239, 239, 239),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Keep your files organized effortlessly with intelligent categorization, safe file handling, and customizable rules. AutoSort monitors your designated folders and automatically moves files to their appropriate categories based on file extensions and custom rules you define.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.kBodyText,
              color: const Color.fromARGB(255, 226, 226, 226),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureTitle extends StatelessWidget {
  final String title;
  final String info;
  const FeatureTitle({required this.title, required this.info, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: AppFontSizes.kSidebarItem,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            info,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: AppFontSizes.kBodyText,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageVersion extends StatelessWidget {
  const ImageVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/images/Autosort-whitebg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'AutoSort',
          style: TextStyle(
            fontSize: AppFontSizes.kPageTitle,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 68, 68, 68),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'Version 0.1.0',
            style: TextStyle(fontSize: 10, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
