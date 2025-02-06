import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String text;
  final Function? onPressed;

  const BotonAzul({
    super.key, 
    required this.text, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 2, // Elevación cuando el botón no está presionado
      shape: const StadiumBorder(), // Forma del botón
      backgroundColor: Colors.blue, // Color de fondo
    ),
    onPressed: () => onPressed!(),
    child: Container(
      width: double.infinity,
      height: 55,
      child: Center(
        child: Text(
          this.text,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    ),
  );
  }

}