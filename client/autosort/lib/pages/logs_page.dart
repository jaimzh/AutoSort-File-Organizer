import 'dart:async';
import 'package:autosort/constants.dart';
import 'package:autosort/models/log_entry.dart';
import 'package:autosort/theme.dart';
import 'package:autosort/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/api_service.dart';

// ----------------- LogsPage -----------------
class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String _selectedFilter = "All Logs";
  late Future<List<LogEntry>> _logsFuture;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _logsFuture = _fetchLogs();

    // auto-refresh every 3000s
    _timer = Timer.periodic(const Duration(seconds: 3000), (_) {
      setState(() {
        _logsFuture = _fetchLogs();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //clear logs api function

  Future<List<LogEntry>> _fetchLogs() async {
    final data = await ApiService.getLogs();
    if (data == null) return [];
    final logs = data.map((e) => LogEntry.fromJson(e)).toList();

    // 👇 Sort logs by timestamp (newest first)
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return logs;
  }

  List<LogEntry> _applyFilter(List<LogEntry> logs) {
    switch (_selectedFilter) {
      case "Errors Only":
        return logs.where((log) => log.status == "error").toList();
      case "Scans Only":
        return logs.where((log) => log.type == "scan").toList();
      case "Monitor Only":
        return logs.where((log) => log.type == "monitor").toList();
      default:
        return logs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Logs',
            style: TextStyle(
              fontSize: AppFontSizes.kPageTitle,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Filter row
          FilterButtons(
            selected: _selectedFilter,
            onSelected: (val) => setState(() => _selectedFilter = val),
          ),
          const SizedBox(height: 20),

          // Main LogsCard (everything inside this one card)
          Expanded(
            child: FutureBuilder<List<LogEntry>>(
              future: _logsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final filteredLogs = _applyFilter(snapshot.data!);

                return LogsCard(
                  entries: filteredLogs,
                  onClear: () async {
                    await ApiService.clearLogs();
                    setState(() {
                      _logsFuture = _fetchLogs();
                    });
                  },
                  onRefresh: () {
                    setState(() {
                      _logsFuture = _fetchLogs();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- Filter Buttons -----------------
class FilterButtons extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;
  const FilterButtons({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ["All Logs", "Errors Only", "Scans Only", "Monitor Only"];

    return Row(
      children: filters.map((f) {
        final bool isSelected = f == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomButton(
            text: f,
            onPressed: () => onSelected(f),
            backgroundColor: isSelected
                ? AppColors.buttonBackground
                : AppColors.primaryBackground, // selected vs normal
            textColor: isSelected
                ? AppColors.buttonText
                : AppColors.secondaryText,
            borderRadius: 8,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            elevation: 0,
            hoverColor: isSelected
                ? AppColors.buttonBackground
                : const Color.fromARGB(19, 13, 13, 13),
          ),
        );
      }).toList(),
    );
  }
}

// ----------------- LogsCard (single card with all logs) -----------------
class LogsCard extends StatelessWidget {
  final List<LogEntry> entries;
  final VoidCallback onRefresh;
  final VoidCallback onClear; // not functional yet
  const LogsCard({
    super.key,
    required this.entries,
    required this.onRefresh,
    required this.onClear,
  });

  IconData _getIcon(LogEntry entry) {
    if (entry.type == "scan") return LucideIcons.search;
    if (entry.type == "monitor") return LucideIcons.eye;
    if (entry.status == "error") return LucideIcons.x;
    return LucideIcons.fileText;
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.fileText, color: AppColors.iconColor),
                  SizedBox(width: 10),
                  Text(
                    "Activity Log",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),

              // Buttons row
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 20,
                      color: AppColors.iconColor,
                    ),
                    tooltip: "Reload",
                    onPressed: onRefresh,
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.iconColor,
                      size: 20,
                    ),
                    tooltip: "Clear Logs",
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.pageBackground,
                          constraints: BoxConstraints.tight(Size(300, 220)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const Text('Clear Logs'),
                          content: const Text(
                            'Are you sure you want to clear all logs?',
                          ),
                          actions: [
                            CustomButton(
                              text: 'Cancel',
                              textColor: AppColors.buttonText,
                              hoverColor: AppColors.buttonHover,
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            CustomButton(
                              text: 'Clear',
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
                        onClear();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          entries.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "No logs available",
                      style: TextStyle(color: AppColors.primaryText),
                    ),
                  ),
                )
              :
                // Logs list
                Expanded(
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      String timeAgo = timeago.format(
                        entry.timestamp,
                        allowFromNow: true,
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              _getIcon(entry),
                              color: AppColors.iconColor,

                              size: 18,
                            ),
                            const SizedBox(width: 12),

                            // Message
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.message,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${entry.type.toUpperCase()} • ${entry.action}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Timestamp
                            Text(
                              timeAgo,
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
