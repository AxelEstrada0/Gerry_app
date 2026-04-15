import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hola_gerry/pages/login_page.dart';
// import 'package:hola_gerry/models/app_user.dart'; // C:\Users\gerar\hola_gerry\lib\app_user.dart
import 'package:hola_gerry/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart'; // 
import 'package:open_filex/open_filex.dart';

// import 'package:pdf/pdf.dart'; // 
// import '../services/user_service.dart'; // 
// import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final userService = UserService();

  Future<void> PDF_G(bool enviar) async {
    final user = FirebaseAuth.instance.currentUser!;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Holaa ${user.email}"),
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final archivo = File("${directory.path}/Gerry_PDF.pdf");

    await archivo.writeAsBytes(await pdf.save());

    final nameFIle = "Gerry_${DateTime.now().microsecondsSinceEpoch}.pdf";

    final ref = FirebaseStorage.instance
      .ref()
      .child("Gerry/${user.uid}/$nameFIle");

    await ref.putFile(archivo);

    final url = await ref.getDownloadURL();

    if (enviar == true) {
      await enviarCorreo(context, url); // return url;
    } else {
      await descargarArchivo(url, nameFIle);
    }  
  }

  Future<void> Excel_G(bool enviar) async {
    final user = FirebaseAuth.instance.currentUser!;

    var excel = Excel.createExcel(); // gs://gerryapp.firebasestorage.app
    Sheet sheet = excel['Sheet1'];

    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue("Holaa ${user.email}");

    final directory = await getTemporaryDirectory(); // await getApplicationDocumentsDirectory();
    final archivo = File("${directory.path}/Gerry_Excel.xlsx");

    await archivo.writeAsBytes(excel.encode()!);

    final nameFIle = "Gerry_${DateTime.now().microsecondsSinceEpoch}.xlsx";

    final ref = FirebaseStorage.instance
      .ref()
      .child("Gerry/${user.uid}/$nameFIle");

    await ref.putFile(archivo);

    final url = await ref.getDownloadURL();

    if (enviar == true) {
      await enviarCorreo(context, url); // return url;
    } else {
      await descargarArchivo(url, nameFIle);
    }    
  }

  Future<void> enviarCorreo(BuildContext context, String? url) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    final body = {
      "destinatario": user.email,
      "asunto": "Addict Gym App",
      "mensaje": "Holaa ${user.email},\n\nTu cuenta fue registrada correctamente.\n\nAddict Gym App",
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

  Future<void> descargarArchivo(String url, String nombreArchivo) async {

    try {

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {

        final directory = await getApplicationDocumentsDirectory();

        final file = File("${directory.path}/$nombreArchivo");

        await file.writeAsBytes(response.bodyBytes);

        print("Archivo guardado en:");
        print(file.path);

        // Aquí se abre automáticamente
        await OpenFilex.open(file.path);

      }

    } catch (e) {

      print("Error descargando archivo: $e");

    }

  }

  @override
  void initState() {
    super.initState();
  }

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

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // final data = snapshot.data!.data() as Map<String, dynamic>;
        // final appUser = AppUser.fromMap(uid, data);

        return Scaffold(
          appBar: AppBar(title: Text('Historial'),),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                          await PDF_G(true);
                      },
                      child: Text("PDF Up"),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        await Excel_G(true);
                      },
                      child: Text("Excel Up"),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                          await PDF_G(false);
                      },
                      child: Text("PDF Down"),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        await Excel_G(false);
                      },
                      child: Text("Excel Down"),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () => enviarCorreo(context, ""),
                  child: Text('Correo de Prueba'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/**
 * await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
 */