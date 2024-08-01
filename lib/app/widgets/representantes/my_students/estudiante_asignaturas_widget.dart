import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';
import 'package:intl/intl.dart';

Widget buildMateriasSection(List<MateriaAprobada> materias) {
  List<MateriaAprobada> materiasAprobadas =
      materias.where((materia) => materia.aprobado ?? false).toList();
  List<MateriaAprobada> materiasReprobadas =
      materias.where((materia) => !(materia.aprobado ?? false)).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (materiasAprobadas.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Materias Aprobadas:',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.contentColorGreen),
            ),
            SizedBox(height: 10),
            buildMateriasList(materiasAprobadas),
          ],
        ),
      if (materiasReprobadas.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Materias Reprobadas:',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.contentColorRed),
            ),
            SizedBox(height: 10),
            buildMateriasList(materiasReprobadas),
          ],
        ),
    ],
  );
}

Widget buildMateriasList(List<MateriaAprobada> materias) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: materias.length,
    itemBuilder: (context, index) {
      MateriaAprobada materia = materias[index];
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        child: ListTile(
          title: Text(materia.nombreMateria.toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Primer Parcial: ${materia.calificacion1}'),
              Text('Segundo Parcial: ${materia.calificacion2}'),
              Text('Promedio Final: ${materia.promedioFinal}'),
              Text('Asistencia: ${materia.asistencia}%'),
              Text('Observación: ${materia.observacion}'),
              Text(
                  'Fecha: ${DateFormat('dd MMM \'del\' yyyy').format(materia.fecha)}')
            ],
          ),
          trailing: Icon(
            materia.aprobado ?? false ? Icons.check_circle : Icons.cancel,
            color: materia.aprobado ?? true
                ? AppColors.contentColorGreen
                : AppColors.contentColorRed,
          ),
        ),
      );
    },
  );
}
