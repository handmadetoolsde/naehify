import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_bottom, size: 80, color: Colors.black26),
          Text(
            'Bisher ist alles leer :(',
            style: TextStyle(color: Colors.black26, fontSize: 16),
          )
        ],
      ),
    );  }
}
