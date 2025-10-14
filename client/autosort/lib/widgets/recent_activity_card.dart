import 'dart:async';
import 'package:autosort/constants.dart';
import 'package:autosort/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/api_service.dart';

class RecentActivityCard extends StatefulWidget {
  const RecentActivityCard({super.key});

  @override
  State<RecentActivityCard> createState() => _RecentActivityCardState();
}

class _RecentActivityCardState extends State<RecentActivityCard> {
  List<Map<String, dynamic>> _activities = [];
  bool _loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadActivities();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Future<void> _loadActivities() async {
    final logs = await ApiService.getLogs();
    if (!mounted) return; // ✅ stop if widget is gone

    if (logs != null) {
      final filtered = logs
          .where((log) => log['file'] != null && log['file'] is Map)
          .toList();

      filtered.sort(
        (a, b) => DateTime.parse(
          b['timestamp'],
        ).compareTo(DateTime.parse(a['timestamp'])),
      );

      if (!mounted) return; // ✅ check again just to be safe
      setState(() {
        _activities = filtered;
        _loading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow:  [
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
            // 🔹 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _loading = true;
                        });
                        _loadActivities();
                      },
                      child: Icon(
                        LucideIcons.refreshCcw,
                        color: AppColors.primaryText,
                      ),
                    ), // just a static "clock/history" icon
                    SizedBox(width: 10),
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.kBodyText,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),

                // 🔹 Refresh button
                // IconButton(
                //   icon: const Icon(
                //     LucideIcons.refreshCcw,
                //     color: AppColors.primaryText,
                //   ),
                //   tooltip: "Refresh",
                //   onPressed: () {
                //     setState(() {
                //       _loading = true;
                //     });
                //     _loadActivities();
                //   },
                // ),
              ],
            ),

            const SizedBox(height: 10),

            // 🔹 Content area
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _activities.isEmpty
                  ? const Center(child: Text("No recent activity"))
                  : ListView.separated(
                      itemCount: _activities.length > 5
                          ? 5
                          : _activities.length,
                      separatorBuilder: (_, __) =>
                           Divider(height: 1, color: AppColors.divider),
                      itemBuilder: (context, index) {
                        final log = _activities[index];
                        final file = log['file'] ?? {};
                        final filename = file['name'] ?? 'Unknown';
                        final category = file['category'] ?? 'Others';

                        final timestamp = log['timestamp'];
                        String timeAgo = '';
                        if (timestamp != null) {
                          try {
                            final time = DateTime.parse(timestamp);
                            timeAgo = timeago.format(time, allowFromNow: true);
                          } catch (_) {}
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          child: Row(
                            children: [
                              // File name
                              Expanded(
                                flex: 3,
                                child: Text(
                                  filename,
                                  style:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Arrow
                               Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: AppColors.iconColor,
                                ),
                              ),

                              // Category
                              Expanded(
                                flex: 2,
                                child: Text(
                                  category,
                                  style:  TextStyle(color: AppColors.secondaryText),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Time ago
                              Text(
                                timeAgo,
                                style:  TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
