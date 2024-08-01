import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoPromedioFinal extends StatefulWidget {
  final List<MateriaAprobada> materias;

  GraficoPromedioFinal(this.materias);

  @override
  State<GraficoPromedioFinal> createState() => _GraficoPromedioFinalState();
}

class _GraficoPromedioFinalState extends State<GraficoPromedioFinal> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: showingSections(),
          centerSpaceRadius: 80,
          startDegreeOffset: 180,
          sectionsSpace: 5,
          centerSpaceColor: AppColors.contentColorGreen,
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.materias.length, (i) {
      final materia = widget.materias[i];
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 14 : 10;
      final double radius = isTouched ? 90 : 90;

      return PieChartSectionData(
        color: getColor(i),
        value: materia.calificacion1,
        title:
            '${materia.nombreMateria}\n Calificación ${materia.calificacion1.toStringAsFixed(1)}\n${materia.nombres ?? ''}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          shadows:
              isTouched ? [Shadow(color: Colors.white, blurRadius: 5)] : [],
        ),
        titlePositionPercentageOffset: 0.6, // Adjust position if necessary
      );
    });
  }

  Color getColor(int index) {
    switch (index % 6) {
      case 0:
        return AppColors.contentColorBlue;
      case 1:
        return AppColors.contentColorGreenBajo;
      case 2:
        return AppColors.contentColorOrange;
      case 3:
        return AppColors.contentColorRed;
      case 4:
        return AppColors.contentColorPink;
      case 5:
        return AppColors.contentColorYellow;
      case 6:
        return AppColors.contentColorPurple;
      case 7:
        return AppColors.contentColorCyan;
      case 8:
        return AppColors.contentColorRedBajo;
      case 9:
        return AppColors.contentColorGreen;
      case 10:
        return AppColors.contentColorPurple;
      default:
        return Colors.blue;
    }
  }
}
