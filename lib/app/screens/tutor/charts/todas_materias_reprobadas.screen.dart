import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoMateriasReprobadas extends StatelessWidget {
  final List<MateriaAprobada> materias;

  GraficoMateriasReprobadas(this.materias);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: showingSections(materias),
          centerSpaceRadius: 80,
          startDegreeOffset: 180,
          sectionsSpace: 5,
          centerSpaceColor: AppColors.contentColorRed,
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<MateriaAprobada> data) {
    if (data.isEmpty) {
      return [];
    }

    double totalCalificaciones =
        data.fold(0, (sum, materia) => sum + (materia.calificacion1));

    return List.generate(data.length, (i) {
      final materia = data[i];
      final double fontSize = 10;
      final double radius = 90;
      final double percentage = totalCalificaciones > 0
          ? (materia.calificacion1) / totalCalificaciones * 100
          : 0;

      return PieChartSectionData(
        color: getColor(i),
        value: percentage,
        title:
            '${materia.nombreMateria}\n Promedio ${materia.promedioFinal}\n${materia.nombres ?? ''}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    });
  }

  Color getColor(int index) {
    switch (index % 6) {
      case 0:
        return AppColors.contentColorRed;
      case 1:
        return AppColors.contentColorBlue;
      case 2:
        return AppColors.contentColorOrange;
      case 3:
        return AppColors.contentColorGreen;
      case 4:
        return AppColors.contentColorPink;
      case 5:
        return AppColors.contentColorPurple;
      case 6:
        return AppColors.contentColorCyan;
      case 7:
        return AppColors.contentColorYellow;
      case 8:
        return AppColors.contentColorRedBajo;
      case 9:
        return AppColors.contentColorBlue;
      case 10:
        return AppColors.contentColorGreen;
      default:
        return AppColors.contentColorRed;
    }
  }
}
