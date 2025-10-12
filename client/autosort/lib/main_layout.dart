import 'package:autosort/pages/autosort_page.dart';
import 'package:autosort/pages/splash_screen.dart';
import 'package:autosort/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:autosort/widgets/sidebar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  Widget _currentPage = const AutosortPage();
  bool _isLoading = true;

  void _onSidebarItemSelected(Widget page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkApiHealth();
  }

  Future<void> _checkApiHealth() async {
    final isHealthy = await ApiService.isApiHealthy();
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading =
          !isHealthy; // if api is healthy then loading is gonna be false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 🔹 Custom title bar (draggable)
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(
                    child: Container(
                      height: 40,
                      color: Colors.black,

                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Text(
                            '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          // Minimize
                          _TitleButton(
                            icon: Icons.remove,
                            onPressed: () => appWindow.minimize(),
                          ),
                          // Maximize / Restore
                          // _TitleButton(
                          //   icon: Icons.crop_square,
                          //   onPressed: () {
                          //     appWindow.maximizeOrRestore();
                          //   },
                          // ),
                          // Close
                          _TitleButton(
                            icon: Icons.close,
                            onPressed: () => appWindow.close(),
                            hoverColor: Colors.red.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Main content row
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds : 1500),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _isLoading
                  ? const SplashContent(key: ValueKey('splash'))
                  : Row(
                      key: const ValueKey('main'),
                      children: [
                        Sidebar(onItemSelected: _onSidebarItemSelected),
                        Expanded(child: _currentPage),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color hoverColor;

  const _TitleButton({
    required this.icon,
    required this.onPressed,
    this.hoverColor = const Color(0xFFAAAAAA),
  });

  @override
  State<_TitleButton> createState() => _TitleButtonState();
}

class _TitleButtonState extends State<_TitleButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: 40,
          color: _hovering
              ? widget.hoverColor.withOpacity(0.2)
              : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 18,
            color: _hovering ? widget.hoverColor : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
