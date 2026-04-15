import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;                               // // Automatic FirebaseAuth
  final String email;                             // Settings => Unique
  final String nombre;                            // Settings .
  final String? telefono;                         // Settings .
  final DateTime? fechaNacimiento;                // Settings .
  final double? edad;                             // // Automatic => Date.now() - Birthday()
  final String? genero;                           // Settings .
  final String? direccion;                        // Settings .
  final Map<String, dynamic>? articulaciones;     // Settings => Map.
  final double? peso;                             // Settings .
  final double? altura;                           // Settings .
  final String? objetivoFitness;                  // Settings .
  final int nivel;                                // // Training
  final DateTime? fechaRegistro;                  // // Automatic => Date.now()
  final Map<String, dynamic>? contactoEmergencia;  // Settings .
  final Map<String, int>? gameStats;
  // final int IMC;
  // final Map<String, dynamic>? juego;

  AppUser({
    required this.uid,
    required this.email,
    required this.nombre,
    this.telefono,
    this.fechaNacimiento,
    this.edad,
    this.genero,
    this.direccion,
    this.articulaciones,
    this.peso,
    this.altura,
    this.objetivoFitness,
    this.nivel = 1,
    this.fechaRegistro,
    this.contactoEmergencia,
    this.gameStats,

  });

  // 🔹 Firestore → AppUser
  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      nombre: data['nombre'] ?? 'Invitado',
      telefono: data['telefono'],
      fechaNacimiento: data['fechaNacimiento'] is Timestamp
          ? (data['fechaNacimiento'] as Timestamp).toDate()
          : null,
      edad: data['edad'],
      genero: data['genero'],
      direccion: data['direccion'],
      articulaciones: data['articulaciones'],
      nivel: data['nivel'] ?? 1,
      fechaRegistro: data['fechaRegistro'] is Timestamp
          ? (data['fechaRegistro'] as Timestamp).toDate()
          : null,
      contactoEmergencia: data["contactoEmergencia"],
      gameStats: data['gameStats'],
    );
  }

  // 🔹 AppUser → Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombre': nombre,
      'telefono': telefono,
      'fechaNacimiento': fechaNacimiento,
      'edad': edad,
      'genero': genero,
      'direccion': direccion,
      'articulaciones': articulaciones,
      'peso': peso,
      'altura': altura,
      'objetivoFitness': objetivoFitness,
      'nivel': nivel,
      'fechaRegistro': FieldValue.serverTimestamp(),
      'contactoEmergencia': contactoEmergencia,
      'gameStats': gameStats,
    };
  }
}
