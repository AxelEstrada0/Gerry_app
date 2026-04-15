import 'dart:math';

class GameService {
  final random = Random();

  Map<String, dynamic> Suma(int nivel) {
    int a = random.nextInt(10);
    int b = random.nextInt(10);

    return {
      "a": a,
      "b": b,
      "respuesta": a + b,
    };
  }

  Map<String, dynamic> Resta(int nivel) {
    int a = random.nextInt(10);
    int b = random.nextInt(10);

    return {
      "a": a, 
      "b": b, 
      "respuesta": a - b,
    };
  }

  bool esCorrecto(int respuestaUsuario, int correcta) {
    return respuestaUsuario == correcta;
  }
}