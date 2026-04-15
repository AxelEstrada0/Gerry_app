import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hola_gerry/models/app_user.dart';
import 'package:hola_gerry/pages/dashboard_page.dart';
import 'package:hola_gerry/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _Email = TextEditingController();
  final _Pass = TextEditingController();
  final _Name = TextEditingController();
  final _Tel = TextEditingController();

  bool _loading = false;
  String _error = '';

  Future<void> _register() async {

    setState(() {
      _loading = true;
    });

    try {

      // 1 crear usuario auth
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _Email.text.trim(),
        password: _Pass.text.trim(),
      );

      final uid = credential.user!.uid;

      // 2 crear documento firestore
      final user = AppUser(
        uid: uid,
        email: _Email.text.trim(),
        nombre: _Name.text.trim(),
        telefono: _Tel.text.trim(),
        nivel: 1,
        fechaRegistro: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(user.toMap());

      /*if (!user.exists) {

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
              "uid": uid,
              "email": FirebaseAuth.instance.currentUser!.email,
              "nivel": 1,
              "fechaRegistro": DateTime.now(),
            });

      }*/

      // 3 navegar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

    } catch (e) {

      print("ERROR: $e");

      setState(() {
        _error = e.toString();
      });

    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _Email.dispose();
    _Pass.dispose();
    _Name.dispose();
    _Tel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(23),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: _Name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nombre(s) Apellido(s)",
                labelText: 'Nombre'),
            ),

            const SizedBox(height: 7),

            TextField(
              controller: _Email,
              // keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "ejemplo@correo.com",
                labelText: 'E-Mail'),
            ),

            const SizedBox(height: 7),

            TextField( // 
              controller: _Pass,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "******",
                labelText: 'Contraseña'),
            ),

            const SizedBox(height: 7),

            TextField(
              controller: _Tel,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "### ### ####",
                labelText: 'Teléfono'),
            ),

            const SizedBox(height: 15),

            _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });

                  await _register();
                  _Email.clear();
                  _Name.clear();
                  _Pass.clear();
                  _Tel.clear();

                  setState(() {
                    _loading = false;
                  });
                },
                child: const Text('Crear Cuenta'),
              ),
            if (_error.isNotEmpty) Text(_error, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
