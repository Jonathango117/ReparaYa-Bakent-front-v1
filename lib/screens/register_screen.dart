
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_screens.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Paleta visual Bevel / ReparaYa.
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _ink = Color(0xFF222326);
  static const Color _charcoal = Color(0xFF1F2025);
  static const Color _cloud = Color(0xFFEBF0F8);
  static const Color _gray = Color(0xFF747679);
  static const Color _sky = Color(0xFFD2E5FF);
  static const Color _blue = Color(0xFF415EEE);
  static const Color _green = Color(0xFF31CE01);
  static const Color _error = Colors.redAccent;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole;

  Future<void> _handleRegister() async {
    if (_isLoading) return;

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona si eres Cliente o Técnico'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        role: _selectedRole!,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. ¡Bienvenido!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo completar el registro. '
              'Comprueba los datos o intenta con otro correo.',
            ),
            backgroundColor: _error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No fue posible conectar con el servidor. '
            'Inténtalo de nuevo.',
          ),
          backgroundColor: _error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ---------- Estilos de los campos ----------

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder border(
      Color color, [
      double width = 1,
    ]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _gray,
        fontSize: 15,
      ),
      prefixIcon: Icon(
        icon,
        color: _gray,
        size: 21,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: _white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 19,
      ),
      border: border(_cloud),
      enabledBorder: border(_cloud),
      focusedBorder: border(_charcoal, 1.4),
      errorBorder: border(_error),
      focusedErrorBorder: border(_error, 1.4),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _ink,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ---------- Selección de tipo de usuario ----------

  Widget _buildRoleCard({
    required String role,
    required String label,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: Material(
        color: isSelected ? _charcoal : _cloud,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() => _selectedRole = role);
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected ? _charcoal : _blue,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? _cloud : _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isSelected
                        ? _cloud.withValues(alpha: 0.75)
                        : _gray,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Requisitos de contraseña ----------

  Widget _passwordRule(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            ok
                ? Icons.check_circle_rounded
                : Icons.circle_outlined,
            size: 16,
            color: ok ? _green : _gray,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: ok ? _ink : _gray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRules() {
    final password = _passwordController.text;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cloud,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _passwordRule(
            '8 caracteres o más',
            password.length >= 8,
          ),
          _passwordRule(
            '1 mayúscula',
            RegExp(r'[A-Z]').hasMatch(password),
          ),
          _passwordRule(
            '1 número',
            RegExp(r'[0-9]').hasMatch(password),
          ),
          _passwordRule(
            '1 carácter especial',
            RegExp(r'[^A-Za-z0-9]').hasMatch(password),
          ),
        ],
      ),
    );
  }

  // ---------- Encabezado ----------

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            _sky,
            Color(0xFFFFF9EE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crea tu cuenta',
            style: TextStyle(
              color: _ink,
              fontSize: 34,
              fontWeight: FontWeight.w600,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Únete a ReparaYa y encuentra la solución '
            'para tus equipos.',
            style: TextStyle(
              color: _gray,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Pantalla ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: _cloud,
                        borderRadius: BorderRadius.circular(999),
                        child: IconButton(
                          tooltip: 'Volver',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: _charcoal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildHeaderCard(),
                    const SizedBox(height: 32),

                    _fieldLabel('¿Cómo quieres usar ReparaYa?'),
                    Row(
                      children: [
                        _buildRoleCard(
                          role: 'cliente',
                          label: 'Cliente',
                          description: 'Busco reparar mis equipos.',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(width: 12),
                        _buildRoleCard(
                          role: 'tecnico',
                          label: 'Técnico',
                          description: 'Ofrezco servicios de reparación.',
                          icon: Icons.build_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Nombre completo
                    _fieldLabel('Nombre completo'),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: _ink),
                      decoration: _inputDecoration(
                        hint: 'Tu nombre',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Correo
                    _fieldLabel('Correo electrónico'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      style: const TextStyle(color: _ink),
                      decoration: _inputDecoration(
                        hint: 'tu@email.com',
                        icon: Icons.mail_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu correo';
                        }

                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(value.trim())) {
                          return 'Ingresa un correo válido';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Teléfono
                    _fieldLabel('Teléfono'),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: _ink),
                      decoration: _inputDecoration(
                        hint: '300 123 4567',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Contraseña
                    _fieldLabel('Contraseña'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: const TextStyle(color: _ink),
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration(
                        hint: 'Crea una contraseña',
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: _gray,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final password = value ?? '';

                        if (password.isEmpty) {
                          return 'Ingresa una contraseña';
                        }
                        if (password.length < 8) {
                          return 'Mínimo 8 caracteres';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(password)) {
                          return 'Debe incluir una mayúscula';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(password)) {
                          return 'Debe incluir un número';
                        }
                        if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
                          return 'Debe incluir un carácter especial';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildPasswordRules(),
                    const SizedBox(height: 20),

                    // Confirmación de contraseña
                    _fieldLabel('Confirmar contraseña'),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: const TextStyle(color: _ink),
                      onFieldSubmitted: (_) => _handleRegister(),
                      decoration: _inputDecoration(
                        hint: 'Repite tu contraseña',
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          tooltip: _obscureConfirmPassword
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: _gray,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma tu contraseña';
                        }

                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Botón de registro
                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _charcoal,
                          foregroundColor: _cloud,
                          disabledBackgroundColor: _gray,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(
                                  color: _white,
                                  strokeWidth: 2.2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Registrarse',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Enlace al login
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          '¿Ya tienes cuenta?',
                          style: TextStyle(
                            color: _gray,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: _ink,
                          ),
                          child: const Text(
                            'Inicia sesión',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
