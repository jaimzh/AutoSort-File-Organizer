import 'dart:async';
import 'package:autosort/theme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/api_service.dart'; // your API service

class RecentActivity extends StatefulWidget {
  const RecentActivity({super.key});

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
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
    _timer?.cancel(); // 👈 stop timer when widget is disposed
    super.dispose();
  }

  Future<void> _loadActivities() async {
    final logs = await ApiService.getLogs();
    if (logs != null) {
      final filtered = logs
          .where((log) => log['file'] != null && log['file'] is Map)
          .toList();

      filtered.sort(
        (a, b) => DateTime.parse(
          b['timestamp'],
        ).compareTo(DateTime.parse(a['timestamp'])),
      );

      setState(() {
        _activities = filtered;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activities.isEmpty) {
      return const Center(child: Text("No recent activity"));
    }

    return ListView.separated(
      itemCount: _activities.length > 5 ? 5 : _activities.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
      itemBuilder: (context, index) {
        final log = _activities[index];
        final file = log['file'] ?? {};
        final filename = file['name'] ?? 'Unknown';
        final category = file['category'] ?? 'Others';

        final timestamp = log['timestamp'];
        DateTime? time;
        String timeAgo = '';
        if (timestamp != null) {
          try {
            time = DateTime.parse(timestamp);
            timeAgo = timeago.format(time, allowFromNow: true);
          } catch (_) {}
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: [
              // 1. File name
              Expanded(
                flex: 3,
                child: Text(
                  filename,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 2. Arrow icon
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.arrow_forward, size: 16, color: Colors.black),
              ),

              // 3. Destination (category)
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      category,
                      style: const TextStyle(color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // 4. Time ago (aligned right)
              Text(
                timeAgo,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        );
      },
    );
  }
}
