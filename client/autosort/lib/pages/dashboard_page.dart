import 'package:autosort/services/api_service.dart';
import 'package:autosort/widgets/custom_button.dart';
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
          const SizedBox(height: 8),
          Text(
            'Overview of your sorting activity and file stats.',
            style: TextStyle(
              fontSize: AppFontSizes.kBodyText,
              color: AppColors.secondaryText,
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
            height: 140, 
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
    this.icon = LucideIcons.chartPie,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                Spacer(),
               
                IconButton(
                  iconSize: 20,
                  color: AppColors.iconColor,
                  tooltip: "Reset counts",
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.pageBackground,
                        constraints: BoxConstraints.tight(Size(300, 220)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        title: Text(
                          'Reset Counts',
                          style: TextStyle(color: AppColors.primaryText),
                        ),
                        content: Text(
                          'Are you sure you want to reset all file counts to zero?',
                          style: TextStyle(color: AppColors.secondaryText),
                        ),
                        actions: [
                          CustomButton(
                            text: 'Cancel',
                            backgroundColor: AppColors.buttonBackground,
                            textColor: AppColors.buttonText,
                            hoverColor: AppColors.buttonHover,
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          CustomButton(
                            text: 'Reset',
                            onPressed: () => Navigator.of(context).pop(true),
                            backgroundColor: AppColors.deleteBtn,
                            hoverColor: AppColors.deleteBtnHover,
                            textColor: AppColors.buttonText,
                            borderColor: AppColors.deleteBtnHover,
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      final result = await ApiService.resetCounts();

                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '✅ Lifetime counts reset successfully',
                            ),
                          ),
                        );
                       
                        final state = context
                            .findAncestorStateOfType<_DashboardPageState>();
                        state?._loadCounts();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('❌ Failed to reset lifetime counts'),
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(LucideIcons.trash),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: content),
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
      width: 160, 
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
