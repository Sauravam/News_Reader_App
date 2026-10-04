import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/connectivity_service.dart';
import '../../../core/widgets/offline_banner.dart';

class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ConnectivityService connectivityService;

  const ShellScreen({
    super.key,
    required this.navigationShell,
    required this.connectivityService,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktopOrTablet = width >= 840.0;

    return Scaffold(
      body: Column(
        children: [
          OfflineBanner(connectivityService: connectivityService),
          Expanded(
            child: isDesktopOrTablet
                ? Row(
                    children: [
                      NavigationRail(
                        selectedIndex: navigationShell.currentIndex,
                        onDestinationSelected: _onDestinationSelected,
                        labelType: NavigationRailLabelType.all,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.newspaper_outlined),
                            selectedIcon: Icon(Icons.newspaper_rounded),
                            label: Text('Home'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.bookmark_outline_rounded),
                            selectedIcon: Icon(Icons.bookmark_rounded),
                            label: Text('Bookmarks'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings_outlined),
                            selectedIcon: Icon(Icons.settings_rounded),
                            label: Text('Settings'),
                          ),
                        ],
                      ),
                      const VerticalDivider(thickness: 1.0, width: 1.0),
                      Expanded(child: navigationShell),
                    ],
                  )
                : navigationShell,
          ),
        ],
      ),
      bottomNavigationBar: isDesktopOrTablet
          ? null
          : NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.newspaper_outlined),
                  selectedIcon: Icon(Icons.newspaper_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bookmark_outline_rounded),
                  selectedIcon: Icon(Icons.bookmark_rounded),
                  label: 'Bookmarks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }
}
