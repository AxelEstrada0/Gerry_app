import 'package:flutter/material.dart';
// import 'package:hola_gerry/models/app_user.dart';
// import 'package:hola_gerry/pages/login_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hola_gerry/services/user_service.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return Scaffold(
      appBar: AppBar(title: Text('Tienda'),),
      body: StreamBuilder(
        stream: userService.streamUser(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // final user = snapshot.data!;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 
              ],
            ),
          );
        },
      ),
    );
  }
}


/**
 * Padding(
        padding: const EdgeInsets.all(16), // 🔹 Padding general
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
          ],
        ),
      ),
 */