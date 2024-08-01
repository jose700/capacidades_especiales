import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  final String content;
  final bool visible;
  final VoidCallback onTap;

  MemoryCard(
      {required this.content, required this.visible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Text(
            visible ? content : '❓',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
