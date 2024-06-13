import 'package:flutter/material.dart'; // Importación del paquete necesario para utilizar Flutter y Material Design

import 'dart:convert'; // Importación para convertir datos entre diferentes formatos 
import 'dart:math'; // Importación para funciones matemáticas avanzadas

void main() {
  runApp(MyApp()); // Función principal que inicia la aplicación Flutter y carga MyApp como raíz
}

/// MyApp es el widget principal de la aplicación.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Científica', // Título de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema de la aplicación con tonos de azul
      ),
      home: CalculadoraCientifica(), // Establece CalculadoraCientifica como la pantalla principal
    );
  }
}

/// CalculadoraCientifica es el widget principal que representa la calculadora científica.
class CalculadoraCientifica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora Científica'), // Barra superior de la aplicación con título
      ),
      body: CalculatorBody(), // Cuerpo de la aplicación donde se encuentra la lógica de la calculadora
    );
  }
}

/// CalculatorBody es un StatefulWidget que contiene la interfaz y la lógica de la calculadora.
class CalculatorBody extends StatefulWidget {
  @override
  _CalculatorBodyState createState() => _CalculatorBodyState(); // Crea el estado mutable de CalculatorBody
}

/// _CalculatorBodyState mantiene el estado para el widget CalculatorBody.
class _CalculatorBodyState extends State<CalculatorBody> {
  final TextEditingController num1Controller = TextEditingController(); // Controlador para el primer número
  final TextEditingController num2Controller = TextEditingController(); // Controlador para el segundo número
  double number1 = 0; // Variable para almacenar el primer número
  double number2 = 0; // Variable para almacenar el segundo número
  double angle = 0; // Variable para almacenar el ángulo en operaciones trigonométricas

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildOperationButton(context, "Suma", () => _performOperation(context, suma)), // Botón para la operación de suma
          buildOperationButton(context, "Resta", () => _performOperation(context, resta)), // Botón para la operación de resta
          buildOperationButton(context, "Multiplicación", () => _performOperation(context, multiplicacion)), // Botón para la operación de multiplicación
          buildOperationButton(context, "División", () => _performOperation(context, division)), // Botón para la operación de división
          buildOperationButton(context, "Seno", () => _performTrigonometricOperation(context, seno)), // Botón para la operación de seno
          buildOperationButton(context, "Coseno", () => _performTrigonometricOperation(context, coseno)), // Botón para la operación de coseno
          buildOperationButton(context, "Tangente", () => _performTrigonometricOperation(context, tangente)), // Botón para la operación de tangente
        ],
      ),
    );
  }

  /// Método para construir un botón de operación con texto y función onPressed especificados.
  Widget buildOperationButton(BuildContext context, String text, void Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text), // Texto mostrado en el botón
      ),
    );
  }

  /// Método que muestra un diálogo para operaciones aritméticas básicas.
  void _performOperation(BuildContext context, double Function(double, double) operation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Operación'), // Título del diálogo
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: num1Controller,
                decoration: InputDecoration(labelText: 'Primer número'), // Campo de entrada para el primer número
                keyboardType: TextInputType.number, // Teclado numérico
                onChanged: (value) => number1 = double.tryParse(value) ?? 0, // Actualiza number1 al valor ingresado
              ),
              TextField(
                controller: num2Controller,
                decoration: InputDecoration(labelText: 'Segundo número'), // Campo de entrada para el segundo número
                keyboardType: TextInputType.number, // Teclado numérico
                onChanged: (value) => number2 = double.tryParse(value) ?? 0, // Actualiza number2 al valor ingresado
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                double result = operation(number1, number2); // Ejecuta la operación con los números ingresados
                _showResult(context, "Resultado", result.toString()); // Muestra el resultado en un nuevo diálogo
              },
              child: Text('Calcular'), // Texto del botón para realizar el cálculo
            ),
          ],
        );
      },
    );
  }

  /// Método que muestra un diálogo para operaciones trigonométricas.
  void _performTrigonometricOperation(BuildContext context, double Function(double) operation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Operación Trigonométrica'), // Título del diálogo
          content: TextField(
            decoration: InputDecoration(labelText: 'Ángulo en grados'), // Campo de entrada para el ángulo
            keyboardType: TextInputType.number, // Teclado numérico
            onChanged: (value) => angle = double.tryParse(value) ?? 0, // Actualiza angle al valor ingresado
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                double result = operation(angle); // Ejecuta la operación trigonométrica con el ángulo ingresado
                _showResult(context, "Resultado", result.toString()); // Muestra el resultado en un nuevo diálogo
              },
              child: Text('Calcular'), // Texto del botón para realizar el cálculo
            ),
          ],
        );
      },
    );
  }

  /// Método que muestra un diálogo con el resultado de la operación.
  void _showResult(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title), // Título del diálogo
          content: Text(message), // Mensaje que muestra el resultado
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: Text('Aceptar'), // Texto del botón para cerrar el diálogo
            ),
          ],
        );
      },
    );
  }

  // Operaciones matemáticas básicas

  double suma(double a, double b) => a + b; // Función para sumar dos números

  double resta(double a, double b) => a - b; // Función para restar dos números

  double multiplicacion(double a, double b) => a * b; // Función para multiplicar dos números

  double division(double a, double b) {
    if (b == 0) {
      throw ArgumentError("No se puede dividir por cero"); // Manejo de excepción para división por cero
    }
    return a / b; // Función para dividir dos números
  }

  // Funciones trigonométricas

  double seno(double anguloGrados) {
    double anguloRadianes = anguloGrados * (pi / 180); // Conversión de grados a radianes
    return sin(anguloRadianes); // Calcula el seno del ángulo en radianes
  }

  double coseno(double anguloGrados) {
    double anguloRadianes = anguloGrados * (pi / 180); // Conversión de grados a radianes
    return cos(anguloRadianes); // Calcula el coseno del ángulo en radianes
  }

  double tangente(double anguloGrados) {
    double anguloRadianes = anguloGrados * (pi / 180); // Conversión de grados a radianes
    return tan(anguloRadianes); // Calcula la tangente del ángulo en radianes
  }
}