import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:capacidades_especiales/app/models/seguimientos-academicos/materias/approved_assignatura_model.dart';

class DatosEstudiante {
  Estudiante estudiante;
  List<MateriaAprobada> materias;

  DatosEstudiante({
    required this.estudiante,
    required this.materias,
  });

  factory DatosEstudiante.fromJson(Map<String, dynamic> json) {
    return DatosEstudiante(
      estudiante: Estudiante.fromJson(json['estudiante']),
      materias: List<MateriaAprobada>.from(
        json['materias'].map((x) => MateriaAprobada.fromJson(x)),
      ),
    );
  }
}
