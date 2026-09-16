import 'package:flutter/material.dart';

import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/features/home/presentation/pages/home_tab.dart';
import 'package:idiomatic_app/features/idioms/presentation/pages/browse_tab.dart';
import 'package:idiomatic_app/features/progress/presentation/pages/progress_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = 0;

  static const _tabs = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view, label: 'Browse'),
    (icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Scaffold(
      body: SafeArea(
        child: switch (_tabIndex) {
          0 => const HomeTab(),
          1 => const BrowseTab(),
          _ => const ProgressTab(),
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 20),
        decoration: BoxDecoration(color: colors.surface, border: Border(top: BorderSide(color: colors.border))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final active = i == _tabIndex;
            final color = active ? colors.primary : colors.textTertiary;
            return GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(active ? tab.activeIcon : tab.icon, size: 20, color: color),
                  const SizedBox(height: 3),
                  Text(tab.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
