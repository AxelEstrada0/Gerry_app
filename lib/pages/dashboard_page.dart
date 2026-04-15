import 'package:flutter/material.dart';
import 'package:hola_gerry/pages/register_page.dart';
import '../widgets/app_card.dart';
import '../core/routes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import '../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hola_gerry/pages/login_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    }
    final uid = user.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set({
              "uid": uid,
              "email": user.email,
              "nivel": 1,
              "fechaRegistro": DateTime.now(),
            });
          /*WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            );
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );*/
        }
        
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final nombre = data["nombre"];
         
        // final appUser = AppUser.fromMap(uid, data);

        return Scaffold(
          appBar: AppBar(
              title: Center(
                child: Column(
                  children: [
                    Text("Bienvenido: $nombre"),
                    Text('Gerry & Niki App'),], // Addict Gym
                  ),
                ),//
              ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                AppCard(
                  title: 'Mi Perfil',
                  subtitle: 'Datos personales y progreso',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),

                AppCard(
                  title: 'Entrenamientos',
                  subtitle: 'Rutinas y ejercicios',
                  icon: Icons.fitness_center,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.training);
                  },
                ),

                AppCard(
                  title: 'Historial',
                  subtitle: 'Progreso y registros',
                  icon: Icons.bar_chart,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.history);
                  },
                ), 

                AppCard(
                  title: 'Tienda',
                  subtitle: 'Productos y Suplementos',
                  icon: Icons.store,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.store);
                  },
                ), 

                AppCard(
                  title: 'Configuración',
                  subtitle: 'Ajuste de Propiedades',
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
