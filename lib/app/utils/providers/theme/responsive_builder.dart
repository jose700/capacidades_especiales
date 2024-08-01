import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop, web }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Size size, DeviceType deviceType)
      builder;

  const ResponsiveBuilder({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DeviceType deviceType;

    if (size.width >= 1200) {
      deviceType = DeviceType.desktop;
    } else if (size.width >= 600) {
      deviceType = DeviceType.tablet;
    } else if (size.width >= 1024) {
      deviceType = DeviceType.web;
    } else {
      deviceType = DeviceType.mobile;
    }

    return builder(context, size, deviceType);
  }
}
