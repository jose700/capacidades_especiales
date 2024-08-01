// custom_sliver_appbar.dart
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 350,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Image.asset(
              'assets/img/capacidad_especial.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Positioned.fill(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
