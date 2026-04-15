import 'package:flutter/material.dart';
import 'package:hola_gerry/pages/settings_page.dart';
import 'package:hola_gerry/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  Future<void> enviarCorreo(String Correo, String Nombre, String url) async {

    final body = {
      "destinatario": '$Correo',
      "asunto": "Actualizacion",
      "mensaje": "Holaa $Nombre,\n\nCuenta Autenticada Correctamente.\n\n\n\nAddict Gym App",
      "mailer": "1",
      "archivo": url,
    };

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-gerryapp.cloudfunctions.net/enviarCorreo'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo enviado correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar correo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  Future<String?> createPaymentIntent(int amount) async {
    try {
      final response = await http.post(
        Uri.parse("https://us-central1-gerryapp.cloudfunctions.net/createPaymentIntent"),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode({
          "amount": amount,
        }),
      );

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["clientSecret"];
      } else {
        throw Exception("Error en response");
      }

    } catch (e) {
      print(e);
      throw Exception("Error en createPaymentIntent");
    }
  }

  Future<void> pagar() async {
    try {
      // 1. Pedir clientSecret
      final clientSecret = await createPaymentIntent(1000); // $5 MXN

      if (clientSecret == null) {
        throw Exception("No se obtuvo clientSecret");
      }

      // 2. Inicializar PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Gym App",
        ),
      );

      // 3. Mostrar UI de Stripe
      await Stripe.instance.presentPaymentSheet();

      // 4. Éxito
      await feedbackPago("success");

    } catch (e, s) {
      if (e is StripeException) {
        await feedbackPago("cancelled");
      } else {
        await feedbackPago("error");
        print("");
        print("ERROR: $e");
        print("STACK: $s");
      }
      debugPrint(e.toString());
    }
  }
  
  Future<void> feedbackPago(String estado) async {
    switch (estado) {

      case "success":
        Vibration.vibrate(duration: 200);
        // await player.play(AssetSource('sounds/success.mp3'));
        print("Pago exitoso ✅");
        break;

      case "error":
        Vibration.vibrate(pattern: [0, 300, 100, 300]);
        // await player.play(AssetSource('sounds/error.mp3'));
        print("Pago fallido ❌");
        break;

      case "cancelled":
        Vibration.vibrate(duration: 100);
        print("Pago cancelado ⚠️");
        break;

      case "processing":
        print("Procesando pago...");
        break;
    }
  }
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();    
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Mi Perfil',),),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ), 
          ],
        ),
        body: StreamBuilder(
        stream: userService.streamUser(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = snapshot.data!;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Holaa: ${user.nombre}", style: const TextStyle(fontSize: 20),),

                // IconButton(onPressed: onPressed, icon: icon),

                const Icon(Icons.person, size: 80),

                Text("Eres Nivel: ${user.nivel}", style: const TextStyle(fontSize: 20),),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => enviarCorreo(user.email.toString(), user.nombre.toString(), ""),
                  child: Text(user.email, style: const TextStyle(fontSize: 20),),
                ),

                Text(user.telefono.toString(), style: const TextStyle(fontSize: 20),),

                ElevatedButton(
                  onPressed: () => {pagar()},
                  child: const Text('Pagar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/**
 * return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Icon(Icons.person, size: 80),
          
          const SizedBox(height: 20),
          
          const Text(
            'Correo del usuario:',
            style: TextStyle(fontSize: 18),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            user. ?? 'Correo no disponible',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      ),
 */