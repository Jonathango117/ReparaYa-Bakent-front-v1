import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import 'home_tab.dart';
import 'placeholder_tab.dart';
import 'profile_tab.dart';

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavItem(this.icon, this.selectedIcon, this.label);
}

/// Contenedor principal. Se adapta al ancho de la pantalla:
/// celular -> barra inferior, tablet/web -> menú lateral.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _wideBreakpoint = 700.0;

  static const _tabs = <Widget>[
    HomeTab(),
    PlaceholderTab(title: 'Técnicos en el mapa', icon: Icons.map_outlined),
    PlaceholderTab(title: 'Mis solicitudes', icon: Icons.assignment_outlined),
    PlaceholderTab(title: 'Chat', icon: Icons.chat_bubble_outline),
    ProfileTab(),
  ];

  static const _items = <_NavItem>[
    _NavItem(Icons.home_outlined, Icons.home_rounded, 'Inicio'),
    _NavItem(Icons.map_outlined, Icons.map_rounded, 'Mapa'),
    _NavItem(Icons.assignment_outlined, Icons.assignment, 'Solicitudes'),
    _NavItem(Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat'),
    _NavItem(Icons.person_outline, Icons.person, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _wideBreakpoint;

        // Contenido centrado con un ancho máximo para que no se estire.
        final content = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: IndexedStack(index: _index, children: _tabs),
          ),
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: wide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _index,
                      onDestinationSelected: (i) => setState(() => _index = i),
                      labelType: NavigationRailLabelType.all,
                      backgroundColor: AppColors.background,
                      indicatorColor: AppColors.redSoft,
                      selectedIconTheme:
                          const IconThemeData(color: AppColors.red),
                      unselectedIconTheme:
                          const IconThemeData(color: AppColors.textMuted),
                      selectedLabelTextStyle: const TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      unselectedLabelTextStyle: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                      destinations: [
                        for (final it in _items)
                          NavigationRailDestination(
                            icon: Icon(it.icon),
                            selectedIcon: Icon(it.selectedIcon),
                            label: Text(it.label),
                          ),
                      ],
                    ),
                    const VerticalDivider(width: 1, color: AppColors.border),
                    Expanded(child: content),
                  ],
                )
              : content,
          bottomNavigationBar: wide
              ? null
              : NavigationBarTheme(
                  data: NavigationBarThemeData(
                    backgroundColor: AppColors.background,
                    indicatorColor: AppColors.redSoft,
                    elevation: 8,
                    height: 68,
                    labelTextStyle: WidgetStateProperty.resolveWith((states) {
                      final selected = states.contains(WidgetState.selected);
                      return TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color:
                            selected ? AppColors.red : AppColors.textMuted,
                      );
                    }),
                  ),
                  child: NavigationBar(
                    selectedIndex: _index,
                    onDestinationSelected: (i) => setState(() => _index = i),
                    destinations: [
                      for (final it in _items)
                        NavigationDestination(
                          icon: Icon(it.icon, color: AppColors.textMuted),
                          selectedIcon:
                              Icon(it.selectedIcon, color: AppColors.red),
                          label: it.label,
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}