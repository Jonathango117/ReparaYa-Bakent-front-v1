import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screens.dart';

const Color _paperWhite = Color(0xFFFFFFFF);
const Color _charcoal = Color(0xFF1F2025);
const Color _ink = Color(0xFF222326);
const Color _cloudCard = Color(0xFFEBF0F8);
const Color _bodyGray = Color(0xFF747679);
const Color _signalGold = Color(0xFFFFCA00);
const Color _heroSky = Color(0xFFD2E5FF);
const Color _metricBlue = Color(0xFF415EEE);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await AuthService().logout();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cerrar la sesión. Inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paperWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 48 : 24,
                          vertical: 20,
                        ),
                        child: _buildHeader(context, isWide),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 48 : 24,
                        ),
                        child: _buildHero(isWide),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 48 : 24,
                          40,
                          isWide ? 48 : 24,
                          0,
                        ),
                        child: _buildSectionHeading(
                          '¿Qué necesitas reparar?',
                          'Encuentra el servicio adecuado para ti.',
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 48 : 24,
                        20,
                        isWide ? 48 : 24,
                        0,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 3 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 180,
                        ),
                        delegate: SliverChildListDelegate(
                          [
                            _ServiceCard(
                              icon: Icons.phone_iphone_rounded,
                              title: 'Celulares',
                              description: 'Pantallas, baterías y más.',
                              accent: _metricBlue,
                              onTap: () => _showComingSoon(context, 'Celulares'),
                            ),
                            _ServiceCard(
                              icon: Icons.computer_rounded,
                              title: 'Computadores',
                              description: 'Mantenimiento y reparación.',
                              accent: _charcoal,
                              onTap: () =>
                                  _showComingSoon(context, 'Computadores'),
                            ),
                            _ServiceCard(
                              icon: Icons.devices_other_rounded,
                              title: 'Otros equipos',
                              description: 'Encuentra ayuda técnica.',
                              accent: const Color(0xFF8B72D9),
                              onTap: () =>
                                  _showComingSoon(context, 'Otros equipos'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 48 : 24,
                          40,
                          isWide ? 48 : 24,
                          24,
                        ),
                        child: _buildTechnicianBanner(
                          context,
                          isWide,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 48 : 24,
                          0,
                          isWide ? 48 : 24,
                          32,
                        ),
                        child: const Center(
                          child: Text(
                            'ReparaYa · Tecnología que vuelve a funcionar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _bodyGray,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: _charcoal,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.build_rounded,
            color: _signalGold,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ReparaYa',
                style: TextStyle(
                  color: _ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Soluciones para tus equipos',
                style: TextStyle(
                  color: _bodyGray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (isWide) ...[
          _HeaderLink(
            label: 'Inicio',
            onTap: () {},
          ),
          const SizedBox(width: 12),
        ],
        Material(
          color: _cloudCard,
          borderRadius: BorderRadius.circular(999),
          child: IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
            icon: const Icon(
              Icons.logout_rounded,
              color: _charcoal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 48 : 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            _heroSky,
            Color(0xFFFFF9EE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(child: _heroText()),
                const SizedBox(width: 32),
                _heroIllustration(size: 190),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroIllustration(size: 112),
                const SizedBox(height: 24),
                _heroText(),
              ],
            ),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: _paperWhite.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'REPARACIONES MÁS FÁCILES',
            style: TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Tu equipo merece\nuna segunda vida.',
          style: TextStyle(
            color: _charcoal,
            fontSize: 36,
            height: 1.12,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Descubre opciones de reparación y encuentra '
          'el servicio que necesitas.',
          style: TextStyle(
            color: _bodyGray,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _heroIllustration({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _paperWhite.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.settings_rounded,
            size: size * 0.76,
            color: _heroSky,
          ),
          Icon(
            Icons.build_rounded,
            size: size * 0.42,
            color: _charcoal,
          ),
          Positioned(
            right: size * 0.12,
            top: size * 0.12,
            child: Container(
              width: size * 0.18,
              height: size * 0.18,
              decoration: const BoxDecoration(
                color: _signalGold,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: _bodyGray,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicianBanner(BuildContext context, bool isWide) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cloudCard,
        borderRadius: BorderRadius.circular(28),
      ),
      child: isWide
          ? Row(
              children: [
                _technicianIcon(),
                const SizedBox(width: 20),
                const Expanded(child: _TechnicianText()),
                const SizedBox(width: 16),
                _technicianButton(context),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _technicianIcon(),
                const SizedBox(height: 20),
                const _TechnicianText(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: _technicianButton(context),
                ),
              ],
            ),
    );
  }

  Widget _technicianIcon() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: _paperWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.handyman_rounded,
        color: _metricBlue,
        size: 29,
      ),
    );
  }

  Widget _technicianButton(BuildContext context) {
    return FilledButton(
      onPressed: () => _showComingSoon(context, 'Buscar técnicos'),
      style: FilledButton.styleFrom(
        backgroundColor: _charcoal,
        foregroundColor: _paperWhite,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        shape: const StadiumBorder(),
      ),
      child: const Text('Buscar técnicos'),
    );
  }

  void _showComingSoon(BuildContext context, String service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$service: esta función estará disponible próximamente.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _TechnicianText extends StatelessWidget {
  const _TechnicianText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Necesitas un técnico?',
          style: TextStyle(
            color: _ink,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Estamos preparando una forma sencilla de conectar '
          'contigo y los profesionales de reparación.',
          style: TextStyle(
            color: _bodyGray,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cloudCard,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _paperWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: accent,
                  size: 25,
                ),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _bodyGray,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: _ink,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}