import 'package:firebase_core/firebase_core.dart';
import 'auth_gate.dart';
import 'package:flutter/material.dart';
import '../core/routes.dart';
import 'firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);// await Firebase.initializeApp();
  Stripe.publishableKey = "pk_live_51Qb4FeD1KqEtuskOxcnISCEvtSD5VPtnodKXVDGcVGKmwU3163lod4sv5pTdVSvz1R1n2kauyEYfwdOWr7mzmtu700TOdew4DM";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      routes: AppRoutes.routes,
    );
  }
}

//import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'pages/login_page.dart';
//import 'pages/register_page.dart';
//import 'pages/home_page.dart';

/*void main() {
  runApp(const MyApp());
}*/

/**
 * 
 * ElevatedButton(
  onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
  },
  child: Text("Main Menu"),
)

 */

/**
 * class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 3'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Volver'),
        ),
      ),
    );
  }
}
 * 
 */

/**
 * class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) { // Bloque Build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gerry App - Nivel 3'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contador: $contador',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    contador++;
                  });
                },
                child: const Text('Sumar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    contador--;
                  });
                },
                child: const Text('Restar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondPage(),
                    ),
                  );
                },
                child: const Text('Ir a Pantalla 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


 * class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gerry App - Dia 2'),
        ),
        body: Center(
          child: Text('He we! que pedo!'),
        ),
      ),
    );
  }
} 
 * 
 */
