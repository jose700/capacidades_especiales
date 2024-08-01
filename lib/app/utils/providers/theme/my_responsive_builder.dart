import 'package:flutter/material.dart';
import 'responsive_builder.dart';

class MyResponsiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size, deviceType) {
        return Scaffold(
          appBar: AppBar(title: Text('Responsive Builder')),
          body: _buildContent(deviceType),
        );
      },
    );
  }

  Widget _buildContent(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return Row(
          children: [
            Expanded(
                child: Container(
                    color: Colors.blue,
                    child: Center(child: Text('Desktop View')))),
            Expanded(
                child: Container(
                    color: Colors.red,
                    child: Center(child: Text('Desktop View')))),
          ],
        );
      case DeviceType.tablet:
        return Column(
          children: [
            Container(
                color: Colors.blue,
                height: 200,
                child: Center(child: Text('Tablet View'))),
            Container(
                color: Colors.red,
                height: 200,
                child: Center(child: Text('Tablet View'))),
          ],
        );
      case DeviceType.mobile:
      default:
        return Column(
          children: [
            Container(
                color: Colors.blue,
                height: 100,
                child: Center(child: Text('Mobile View'))),
            Container(
                color: Colors.red,
                height: 100,
                child: Center(child: Text('Mobile View'))),
          ],
        );
    }
  }
}
