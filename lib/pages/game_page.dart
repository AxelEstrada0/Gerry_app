import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:hola_gerry/services/user_service.dart';
import 'package:hola_gerry/services/game_service.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final userService = UserService();
  final gameService = GameService();

  int level = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hora de Jugar"),),
      body: Padding(
        padding: const EdgeInsets.all(23), 
        child: StreamBuilder(
          stream: userService.streamUser(), 
          builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final usuario = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Nivel Inicial: ${usuario.nivel}   Niveles a Agregar: ${level}"),

                    SizedBox(height: 23,),

                    Text("Ejercicio"),
                  ],
                ),
              );
            }
          ),
        ),
    );
  }
}