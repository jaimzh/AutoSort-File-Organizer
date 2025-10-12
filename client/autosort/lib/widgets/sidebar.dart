import 'package:autosort/my_flutter_app_icons.dart';
import 'package:autosort/pages/about_page.dart';
import 'package:autosort/pages/autosort_page.dart';
import 'package:autosort/pages/logs_page.dart';
import 'package:autosort/pages/rules_page.dart';
import 'package:autosort/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:autosort/pages/dashboard_page.dart';
import 'package:autosort/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Sidebar extends StatefulWidget {
  final Function(Widget) onItemSelected;

  const Sidebar({super.key, required this.onItemSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late List<CollapsibleItem> _items;

  @override
  void initState() {
    super.initState();

    _items = [
      CollapsibleItem(
        text: 'AutoSort',
        // icon: LucideIcons.house,
        icon: MyFlutterApp.union,
        onPressed: () => widget.onItemSelected(const AutosortPage()),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Dashboard',
        icon: LucideIcons.chartArea,
        onPressed: () => widget.onItemSelected(const DashboardPage()),
      ),
      CollapsibleItem(
        text: 'Logs',
        icon: LucideIcons.fileText,
        onPressed: () => widget.onItemSelected(const LogsPage()),
      ),
      CollapsibleItem(
        text: 'Rules',
        icon: LucideIcons.scroll,
        onPressed: () => widget.onItemSelected(const RulesPage()),
      ),
      CollapsibleItem(
        text: 'Settings',
        icon: Icons.settings_outlined,
        onPressed: () => widget.onItemSelected(const SettingsPage()),
      ),
      CollapsibleItem(
        text: 'About',
        icon: Icons.info_outline,
        onPressed: () =>
            widget.onItemSelected(const Center(child: AboutPage())),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CollapsibleSidebar(
      items: _items,

      body: Container(),

      // leave empty ✅
      itemPadding: 15,
      screenPadding: 8,
      showTitle: false,
      minWidth: 80,
      avatarImg: const AssetImage('assets/images/avatar.png'),
      title: 'AutoSort',
      isCollapsed: size.width <= 800,
      selectedIconBox: const Color.fromARGB(0, 255, 255, 255),
      iconSize: 25,
      backgroundColor: Colors.black,
      selectedTextColor: Colors.white,
      unselectedTextColor: const Color.fromARGB(114, 255, 255, 255),
      selectedIconColor: Colors.white,
      unselectedIconColor: const Color.fromARGB(114, 255, 255, 255),
      textStyle: const TextStyle(fontFamily: 'Inter'),

      customItemOffsetX: 10,
      collapseOnBodyTap: true,
      titleBack: false,
      toggleTitle: "",
      borderRadius: 0,
      maxWidth: 220,

      sidebarBoxShadow: [
        BoxShadow(
          color: const Color.fromARGB(0, 255, 255, 255),
          blurRadius: 0,
          spreadRadius: 0,
          offset: Offset(0, 0),
        ),
      ],
    );
  }
}
