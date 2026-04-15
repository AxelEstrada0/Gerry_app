import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hola_gerry/models/app_user.dart';
import 'package:hola_gerry/services/game_service.dart';
import 'package:hola_gerry/services/user_service.dart';
import 'dart:math';
import 'dart:async';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final userService = UserService();
  final gameService = GameService();
  final _answer = TextEditingController();
  int _respuesta = 0;
  final random = Random();
  String Resultado = "...";
  int tiempo = 10;
  bool pausado = false;
  List<String> simbolos = [];
  //Timer? timer;

  int level = 0;
  late int a;
  late int b;
  late int c;

  Map<String, int> estadisticas = {
    "total": 0,
    "wins": 0,
    "fails": 0,
  };

  void nuevaPregunta(AppUser usuario) {
    final pregunta = gameService.Suma(usuario.nivel);

    setState(() {
      a = pregunta["a"];
      b = pregunta["b"];
      _respuesta = pregunta["respuesta"];
      _answer.clear();
    });
  }

  void Suma() {
    setState(() {
      a = random.nextInt(10);
      b = random.nextInt(10);
      _respuesta = a + b;
      _answer.clear();
    });
  }
  
  int calcularEdad(DateTime nacimiento) {
    final hoy = DateTime.now();

    int edad = hoy.year - nacimiento.year;

    if (hoy.month < nacimiento.month ||
      (hoy.month == nacimiento.month && hoy.day < nacimiento.day)) {
      edad--;
    }

    return edad;
  }

  void generarPregunta() { // AppUser usuario
    // final edad = calcularEdad(usuario.fechaNacimiento!);

    setState(() {
      a = DateTime.now().year;
      b = 1999; // usuario.fechaNacimiento!.year
      _respuesta = a - b; // edad
      _answer.clear();
    });
  }

  /*void iniciarTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!pausado) {
        setState(() {
          tiempo--;

          if (tiempo <= 0) {
            timer.cancel();
            tiempo = 10;
            generarPregunta();
          }
        });
      }
    });
  }*/

  @override
  void initState() {
    super.initState();
    Suma();
    //iniciarTimer();
  }

  @override
  void dispose() {
    //timer?.cancel();
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title: const Text('Entrenamientos')),
      body: StreamBuilder(
        stream: userService.streamUser(), 
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final usuario = snapshot.data!;
          // final stats = usuario.gameStats ?? {"total": 0, "wins": 0, "fails": 0}; // 
          int tier = usuario.nivel ~/ 10;
          int selector = random.nextInt(tier + 1);

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text("Nivel Inicial: ${usuario.nivel}   Niveles a Agregar: ${level}"),
                // Text("Jugados: ${stats["total"]!}   Ganados: ${stats["wins"]!}   Perdidos: ${stats["fails"]!}"),

                SizedBox(height: 10,),

                Text(
                  Resultado,
                  style: const TextStyle(fontSize: 20),
                ),

                SizedBox(height: 15,),

                Text(
                  "$a + $b = ?",
                  style: const TextStyle(fontSize: 30),
                ),

                SizedBox(height: 15,),

                TextField(
                  controller: _answer,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // hintText: "$a + $b = ", 
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 10,),

                /* Text(
                  "Tiempo: $tiempo",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),*/

                SizedBox(height: 10,),

                pausado
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: pausado ? null : () async {
                      setState(() {
                        pausado = true;
                      });

                      // Map<String, dynamic> data = {}; // tiempo = min(tiempo + 10, 20);

                      if (_answer.text == _respuesta.toString()) {
                        _answer.clear();
                        level = level + 1;
                        // stats["wins"] = stats["wins"]! + 1;
                        Resultado = "Correcto !";
                        setState(() {});
                        /* await Future.delayed(const Duration(milliseconds: 501));
                        Resultado += ", + 1 punto";
                        await Future.delayed(const Duration(milliseconds: 501));
                        Resultado += ", + 10 segs";*/
                      } else {
                        _answer.clear();
                        level = level - 1;
                        // stats["fails"] = stats["fails"]! + 1;
                        Resultado = "Noo ... era ${_respuesta.toString()}";
                        setState(() {});
                        /* await Future.delayed(const Duration(milliseconds: 501));
                        Resultado += ", - 1 punto";
                        await Future.delayed(const Duration(milliseconds: 501));
                        Resultado += ", otro?";*/
                      }

                      // await userService.updateUser(data);

                      await Future.delayed(const Duration(milliseconds: 1500));

                      // stats["total"] = stats["total"]! + 1;

                      nuevaPregunta(usuario); // nueva operación

                      Resultado = "...";

                      setState(() {
                        pausado = false;
                      });
                    },
                    child: const Text("LISTO"),
                  ),

                  SizedBox(height: 50,),

                  ElevatedButton(
                    onPressed: () async {
                      Resultado = "";

                      _answer.clear();

                      Map<String, dynamic> data = {};

                      data['nivel'] = usuario.nivel + level;

                      level = 0;

                      await userService.updateUser(data);
                    },
                    child: Text("Guardar progreso"),
                  ),

                  SizedBox(height: 100,),

                  ElevatedButton(
                    onPressed: () async {
                      Resultado = "";

                      _answer.clear();

                      Map<String, dynamic> data = {};

                      data['nivel'] = 1;

                      await userService.updateUser(data);

                      nuevaPregunta(usuario);
                    }, 
                    child: Text("RESTART"), 
                  ),
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        setState(() {
                          pausado = true; 
                        }),
                        //timer?.cancel(),
                      },
                      child: Text('Pausa'),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        setState(() {
                          pausado = false; 
                        }),
                        //iniciarTimer()
                      },
                      child: Text('Reanudar'),
                    ),
                  ],
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}