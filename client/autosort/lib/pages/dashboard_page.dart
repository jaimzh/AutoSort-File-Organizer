import 'package:autosort/services/api_service.dart';
import 'package:autosort/widgets/file_sorted_chart.dart';
import 'package:autosort/widgets/recent_activity_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../constants.dart';
import '../theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic> _counts = {};

  final List<String> _order = [
    "Total",
    "Videos",
    "Images",
    "Documents",
    "Audio",
    "Archives",
    "Others",
  ];

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadCounts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadCounts() async {
    final counts = await ApiService.getCounts();
    if (counts != null) {
      setState(() {
        _counts = counts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prepare ordered keys dynamically
    List<String> orderedKeys = [
      ..._order.where((k) => _counts.containsKey(k)), // known keys in order
      ..._counts.keys.where(
        (k) => !_order.contains(k),
      ), // append unknown/new keys
    ];

    return Container(
      color: AppColors.pageBackground,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: AppFontSizes.kPageTitle,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Top cards row
          Expanded(
            child: Row(
              children: const [
                DashboardCard(
                  title: 'Files Sorted',
                  content: FilesSortedChart(),
                ),
                SizedBox(width: 20),
                RecentActivityCard(),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Dynamic file count cards
          SizedBox(
            height: 140, // must be >= FileCountCard height
            child: _counts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    radius: const Radius.circular(8),
                    thickness: 6,

                    interactive: true,
                    child: ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: orderedKeys.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final key = orderedKeys[index];
                        final value = _counts[key] ?? 0;

                        // Map icons dynamically
                        IconData icon;
                        switch (key.toLowerCase()) {
                          case "videos":
                            icon = LucideIcons.video;
                            break;
                          case "images":
                            icon = LucideIcons.image;
                            break;
                          case "documents":
                            icon = LucideIcons.fileText;
                            break;
                          case "audio":
                            icon = LucideIcons.music;
                            break;
                          case "archives":
                            icon = LucideIcons.archive;
                            break;
                          case "total":
                            icon = LucideIcons.layers;
                            break;
                          default:
                            icon = LucideIcons.folder;
                        }

                        return FileCountCard(
                          title: key,
                          count: value,
                          icon: icon,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// DashboardCard widget
class DashboardCard extends StatelessWidget {
  final String title;
  final Widget content;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.content,
    this.icon = LucideIcons.folderOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20), // ✅ same as FileConfigCard
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryText),
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
            Expanded(child: content), // ✅ content area stays flexible
          ],
        ),
      ),
    );
  }
}

// FileCountCard widget
class FileCountCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const FileCountCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, // pick what works for your layout
      height: 140,
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.iconColor, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                      color: AppColors.primaryText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
