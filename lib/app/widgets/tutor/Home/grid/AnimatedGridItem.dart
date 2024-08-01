import 'package:flutter/material.dart';

class AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final Function() onTap;

  const AnimatedGridItem({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  _AnimatedGridItemState createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 200), // Reducir la duración de la animación
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut, // Aplicar una curva de animación suave
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_animation.value * 0.1), // Ajustar el valor de escala
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
