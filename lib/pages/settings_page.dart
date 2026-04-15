import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hola_gerry/pages/profile_page.dart';
import '../pages/login_page.dart';
import 'package:hola_gerry/services/user_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final userService = UserService();

  final _Name = TextEditingController();
  final _Phone = TextEditingController();
  final _Address = TextEditingController();
  final _Weight = TextEditingController();
  final _Height = TextEditingController();
  final _Goal = TextEditingController();

  String Genre = "Diferente";
  TextEditingController _passConfirm = TextEditingController();

  bool _loading = false;
  
  DateTime? fechaNacimiento;

  Map<String, bool> Articulaciones = { // "": false,
    "Hombros": false,
    "Lumbar": false,
    "Rodillas": false,
  };

  Future<void> seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        fechaNacimiento = fecha;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return Scaffold( // title: const Text('Configuración'), titleTextStyle: TextStyle(fontSize: 23),
      appBar: AppBar(title: Text('Configuracion')), // , titleTextStyle: TextStyle(fontSize: 23),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder( //  padding: EdgeInsets.all(20),       
          stream: userService.streamUser(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final user = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [ // const Text('Ajustes', style: TextStyle(fontSize: 22),),

                  IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("He we! Que pedo!"),
                          );
                        },
                      );
                    },
                  ),

                  TextField(
                    controller: _Name,
                    decoration: InputDecoration(
                      labelText: "Nombre(s) y Apellido(s)",
                      hintText: user.nombre,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  TextField(
                    controller: _Phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Numero Telefonico",
                      hintText: user.telefono ?? "### ### ####",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  TextField(
                    controller: _Address,
                    decoration: InputDecoration(
                      labelText: "Direccion Domiciliar (Opcional)",
                      hintText: user.direccion ?? "Opcional",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  TextField(
                    controller: _Weight,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Peso, en Kilogramos",
                      hintText: user.peso.toString(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  TextField(
                    controller: _Height,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Altura, en Metros",
                      hintText: user.altura.toString(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RadioListTile(
                        title: const Text("Masculino"),
                        value: "Masculino", 
                        groupValue: Genre,
                        onChanged: (value) {
                            setState(() {
                              Genre = value!;
                            });
                          },
                        ),
                      RadioListTile(
                        title: const Text("Femenino"),
                        value: "Femenino", 
                        groupValue: Genre,
                        onChanged: (value) {
                            setState(() {
                              Genre = value!;
                            });
                          },
                        ),
                      RadioListTile(
                        title: const Text("Diferente"),
                        value: "Diferente", 
                        groupValue: Genre,
                        onChanged: (value) {
                            setState(() {
                              Genre = value!;
                            });
                          },
                        ),
                      // RadioGroup(onChanged: onChanged, child: child)
                    ],
                  ),
                  
                  const SizedBox(height: 10),

                  TextField(
                    controller: _Goal,
                    decoration: InputDecoration(
                      hintText: user.objetivoFitness ?? "Motivo de Inscripcion",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: seleccionarFecha,
                    child: Text(
                      fechaNacimiento == null
                          ? "Fecha de Nacimiento"
                          : "${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}",
                    ),
                  ),

                  const SizedBox(height: 10,),

                  Column(
                    children: Articulaciones.keys.map((key) {

                      return CheckboxListTile(
                        title: Text(key),
                        value: Articulaciones[key],
                        onChanged: (value) {
                          setState(() {
                            Articulaciones[key] = value!;
                          });
                        },
                      );

                    }).toList(),
                  ),

                  const SizedBox(height: 23),

                  _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });

                          Map<String, dynamic> data = {};

                          if (_Name.text.trim().isNotEmpty) {
                            data["nombre"] = _Name.text.trim();
                          }

                          if (_Phone.text.trim().isNotEmpty) {
                            data["telefono"] = _Phone.text.trim();
                          }

                          if (fechaNacimiento != null) {
                            data["fechaNacimiento"] = fechaNacimiento;
                          }

                          data["direccion"] = _Address.text.trim();

                          if (_Weight.text.trim().isNotEmpty) {
                            data["nombre"] = _Height.text.trim();
                          }

                          if (_Height.text.trim().isNotEmpty) {
                            data["nombre"] = _Weight.text.trim();
                          }

                          if (_Goal.text.trim().isNotEmpty) {
                            data["nombre"] = _Goal.text.trim();
                          }

                          data["articulaciones"] = Articulaciones;
                          data["genero"] = Genre;

                          try {
                            await userService.updateUser(data);
                          } catch (e) {
                            if (e is FirebaseAuthException) {
                              setState(() {
                                print(e.message ?? "Error de registro");
                              });
                            }
                          }

                          setState(() {
                            _loading = false;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => ProfilePage()),
                          );
                        },                
                          child: Text('Guardar'),
                      ),
                  
                  
                  const SizedBox(height: 23),
                  
                  ElevatedButton(
                    // style: ButtonStyle(backgroundColor: Color.fromARGB(0, 7, 184, 4)),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text('Cerrar Sesión', style: TextStyle(fontSize: 15),),
                  ),

                  SizedBox(height: 50,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirmar contraseña"),
                            content: TextField(
                              controller: _passConfirm,
                              obscureText: true,
                              decoration: InputDecoration(labelText: "Contraseña"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {

                                  await userService.deleteUser(
                                    FirebaseAuth.instance.currentUser!.email!,
                                    _passConfirm.text.trim(),
                                  );

                                  Navigator.pop(context);
                                },
                                child: Text("Confirmar"),
                              ),
                            ],
                          );
                        },
                      );

                      // await userService.deleteUser();

                      // Navigator.pushReplacementNamed(context, "/login");

                    },
                    child: const Text("Eliminar Cuenta"),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

/*
Map<String, int> calcularEdad(DateTime nacimiento) {
    final hoy = DateTime.now();

    int edad = hoy.year - nacimiento.year;

    if (hoy.month < nacimiento.month ||
        (hoy.month == nacimiento.month && hoy.day < nacimiento.day)) {
      edad--;
    }

    final ultimoCumple = DateTime(
      hoy.year,
      nacimiento.month,
      nacimiento.day,
    );

    final dias = hoy.difference(ultimoCumple).inDays;

    return {
      "anios": edad,
      "dias": dias < 0 ? hoy.difference(
        DateTime(hoy.year - 1, nacimiento.month, nacimiento.day)
      ).inDays : dias
    };
  }

  final _Birthday = calcularEdad(user.fechaNacimiento!);
  */

/*
class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return StreamBuilder<AppUser>(
      stream: userService.streamUser(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data!;

        return child;
      },
    );
  }
}
*/