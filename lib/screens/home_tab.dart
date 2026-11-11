import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/technician.dart';
import '../widgets/technician_card.dart';

class _Category {
  final IconData icon;
  final String label;
  const _Category(this.icon, this.label);
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _selected = 'Todos';

  static const _categories = <_Category>[
    _Category(Icons.apps_rounded, 'Todos'),
    _Category(Icons.smartphone, 'Celulares'),
    _Category(Icons.computer, 'Computadores'),
    _Category(Icons.tv, 'Televisores'),
    _Category(Icons.devices_other, 'Otros'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selected == 'Todos'
        ? mockTechnicians
        : mockTechnicians.where((t) => t.specialty == _selected).toList();

    final topRated = [...mockTechnicians]
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildSearch(),
          const SizedBox(height: 22),
          _buildBanner(),
          const SizedBox(height: 26),
          _sectionTitle('Categorías'),
          const SizedBox(height: 12),
          _buildCategories(),
          const SizedBox(height: 26),
          _sectionTitle('Mejor calificados'),
          const SizedBox(height: 12),
          SizedBox(
            height: 196,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topRated.take(4).length,
              itemBuilder: (_, i) =>
                  TechnicianFeaturedCard(technician: topRated[i]),
            ),
          ),
          const SizedBox(height: 26),
          _sectionTitle('Técnicos cercanos', action: 'Ver todos'),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No hay técnicos en esta categoría todavía.',
                    style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, c) {
                // 1 columna en celular, 2 en tablet, 3 en pantalla grande.
                final cols =
                    c.maxWidth >= 900 ? 3 : (c.maxWidth >= 600 ? 2 : 1);
                const gap = 12.0;
                final itemWidth = (c.maxWidth - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing: gap,
                  children: [
                    for (final t in filtered)
                      SizedBox(
                        width: itemWidth,
                        child: TechnicianCard(technician: t),
                      ),
                  ],
                );
              },
            ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Datos de ejemplo (demo)',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: AppColors.redSoft,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: AppColors.red),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hola 👋',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.place, size: 16, color: AppColors.red),
                  SizedBox(width: 4),
                  Text(
                    'Ubicación por definir', // TODO: se reemplaza con el GPS
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded,
                color: AppColors.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {}, // TODO: pantalla de búsqueda
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.search, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'Busca un técnico o servicio',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        constraints: const BoxConstraints(minHeight: 150),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.red, AppColors.redDark],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -40,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 22,
              top: 0,
              bottom: 0,
              child: Icon(Icons.build_circle_outlined,
                  size: 84, color: Colors.white.withValues(alpha: 0.9)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Repara tu equipo\ncon el técnico ideal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Compara precios y calificaciones',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Explorar',
                      style: TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final c = _categories[i];
          final selected = c.label == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = c.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 84,
              decoration: BoxDecoration(
                color: selected ? AppColors.red : AppColors.background,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: selected ? AppColors.red : AppColors.border),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.red.withValues(alpha: 0.30),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(c.icon,
                      size: 28,
                      color: selected ? Colors.white : AppColors.red),
                  const SizedBox(height: 8),
                  Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: () {},
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.red,
              ),
            ),
          ),
      ],
    );
  }
}