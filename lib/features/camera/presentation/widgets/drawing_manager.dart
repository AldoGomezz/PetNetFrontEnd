import 'package:flutter/material.dart';

// Clase para gestionar el dibujo en la pantalla

class DrawingManager {
  // Lista de trazos dibujados
  List<List<Offset>> strokes = [];
  // Trazo actual en proceso de dibujo
  List<Offset> currentStroke = [];
  // Color del trazo actual
  Color color = Colors.yellow;

  // Método para comenzar un nuevo trazo
  void startStroke(Offset position) {
    // Se crea un nuevo trazo con la posición inicial
    currentStroke = [position];
    // Se agrega el trazo a la lista de trazos
    strokes.add(currentStroke);
  }

  // Método para continuar un trazo existente
  void continueStroke(Offset position) {
    // Se añade la posición actual al trazo actual
    currentStroke.add(position);
  }

  // Método para finalizar un trazo
  void endStroke() {
    // Se reinicia el trazo actual
    currentStroke = [];
  }

  // Método para deshacer el último trazo
  void undo() {
    if (strokes.isNotEmpty) {
      // Se elimina el último trazo de la lista
      strokes.removeLast();
    }
  }
}

// Clase para pintar los trazos en la pantalla
class DrawingPainter extends CustomPainter {
  // Lista de trazos a dibujar
  final List<List<Offset>> strokes;
  // Color de los trazos
  final Color color;

  DrawingPainter({required this.strokes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color // Se establece el color de los trazos
      ..strokeCap =
          StrokeCap.round // Se define el estilo de los extremos de los trazos
      ..strokeWidth = 5.0; // Se establece el ancho de los trazos

    // Se recorren todos los trazos
    for (final stroke in strokes) {
      // Se dibuja una línea entre cada par de puntos del trazo
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Se vuelve a pintar en cada actualización
  }
}
