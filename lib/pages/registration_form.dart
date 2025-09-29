import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String? _name;
  // ignore: unused_field
  String? _email;
  String? _avatarUrl;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Card(
                elevation: 16,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.green[200],
                                backgroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty
                                    ? NetworkImage(_avatarUrl!)
                                    : const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    final url = await showDialog<String>(
                                      context: context,
                                      builder: (context) {
                                        String tempUrl = '';
                                        return AlertDialog(
                                          title: const Text('Choisir une photo de profil'),
                                          content: TextFormField(
                                            decoration: const InputDecoration(hintText: 'URL de l\'image'),
                                            onChanged: (value) => tempUrl = value,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, tempUrl),
                                              child: const Text('Valider'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (url != null && url.isNotEmpty) {
                                      setState(() {
                                        _avatarUrl = url;
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              prefixIcon: const Icon(Icons.person, color: Colors.green),
                              filled: true,
                              fillColor: Colors.green[50],
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Entrez votre nom' : null,
                            onChanged: (value) => _name = value,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email, color: Colors.green),
                              filled: true,
                              fillColor: Colors.green[50],
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            validator: (value) => value == null || !value.contains('@') ? 'Entrez un email valide' : null,
                            onChanged: (value) => _email = value,
                          ),
                          const SizedBox(height: 24),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 8,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                                  );
                                }
                              },
                              child: const Text(
                                'S\'inscrire',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
