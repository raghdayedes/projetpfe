import 'package:flutter/material.dart';
import 'zones_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifiantController =
      TextEditingController();
  final TextEditingController _motDePasseController =
      TextEditingController();

  bool _motDePasseVisible = false;
  bool _loading           = false;
  String? _erreur;

  static const String _identifiantValide = 'responsable';
  static const String _motDePasseValide  = 'desenfumage2026';

  void _seConnecter() {
    setState(() {
      _erreur  = null;
      _loading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      final id  = _identifiantController.text.trim();
      final mdp = _motDePasseController.text.trim();

      if (id == _identifiantValide &&
          mdp == _motDePasseValide) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ZonesScreen(),
          ),
        );
      } else {
        setState(() {
          _loading = false;
          _erreur  = 'Identifiant ou mot de passe incorrect.';
        });
      }
    });
  }

  @override
  void dispose() {
    _identifiantController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ── Logo MédiS ────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.network(
                  'https://www.medis.com.tn/wp-content/uploads/2019/01/logo-medis.png',
                  height: 100,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child,
                      loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.blue),
                      ),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Column(
                      children: [
                        Icon(Icons.business,
                            color: Colors.blue[800],
                            size: 60),
                        Text(
                          'MédiS',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ── Titre ─────────────────────────────
              Text(
                'Système Désenfumage',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Connectez-vous pour accéder\nau tableau de supervision',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // ── Carte formulaire ──────────────────
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // ── Identifiant ────────────────
                    const Text(
                      'Identifiant',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _identifiantController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText:
                            'Entrez votre identifiant',
                        prefixIcon: const Icon(
                            Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.red[700]!,
                              width: 1.5),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Mot de passe ───────────────
                    const Text(
                      'Mot de passe',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _motDePasseController,
                      obscureText: !_motDePasseVisible,
                      decoration: InputDecoration(
                        hintText:
                            'Entrez votre mot de passe',
                        prefixIcon:
                            const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _motDePasseVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _motDePasseVisible =
                                  !_motDePasseVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.red[700]!,
                              width: 1.5),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14),
                      ),
                      onSubmitted: (_) => _seConnecter(),
                    ),

                    const SizedBox(height: 16),

                    // ── Message erreur ─────────────
                    if (_erreur != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius:
                              BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.red[200]!,
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red[700],
                                size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _erreur!,
                                style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // ── Bouton connexion ───────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            _loading ? null : _seConnecter,
                        child: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Se connecter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Mention sécurité ──────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security,
                      size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    'Accès réservé au responsable habilité',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}