import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../patient/patient_home.dart';
import '../caretaker/caretaker_home.dart';

class LoginScreen extends StatefulWidget {
  final String role; // 'patient' or 'caretaker'
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _loading = false;

  final supabase = Supabase.instance.client;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: _loginContent(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= UI CONTENT =================

  Widget _loginContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Logo
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1976D2).withOpacity(0.1),
          ),
          child: Icon(
            widget.role == 'patient' ? Icons.person : Icons.health_and_safety,
            size: 44,
            color: const Color(0xFF1976D2),
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'CareLink',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          widget.role == 'patient' ? 'Patient Login' : 'Caretaker Login',
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),

        const SizedBox(height: 28),

        /// Login Form
        Form(
          key: _formKey,
          child: Column(
            children: [
              _emailField(),
              const SizedBox(height: 16),
              _passwordField(),
              const SizedBox(height: 26),
              _loginButton(),
            ],
          ),
        ),

        const SizedBox(height: 14),

        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Change role'),
        ),
      ],
    );
  }

  /// ================= INPUT FIELDS =================

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email, color: Color(0xFF1976D2)),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your email';
        }
        if (!value.contains('@')) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF1976D2)),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your password';
        }
        if (value.length < 6) {
          return 'Minimum 6 characters';
        }
        return null;
      },
    );
  }

  /// ================= LOGIN BUTTON =================

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
        onPressed: _loading ? null : _login,
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Login as ${widget.role == 'patient' ? 'Patient' : 'Caretaker'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  /// ================= AUTH LOGIC =================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final res = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = res.user;
      if (user == null) throw 'Login failed';

      final profile = await supabase
          .from('user_profiles')
          .select('role')
          .eq('user_id', user.id)
          .single();

      if (profile['role'] != widget.role) {
        throw 'This account is not registered as ${widget.role}.';
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => widget.role == 'patient'
              ? PatientHome(patientId: user.id)
              : CaretakerHome(caretakerId: user.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }
}
