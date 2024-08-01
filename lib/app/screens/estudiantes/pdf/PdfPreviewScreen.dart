import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:capacidades_especiales/app/widgets/tutor/Home/messages/dialogs/login_message.dart';
import 'package:capacidades_especiales/app/models/estudiantes/student_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';

class PdfPreviewScreen extends StatefulWidget {
  final List<Estudiante> estudiantes;

  PdfPreviewScreen({required this.estudiantes});

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  String? localFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _generateAndSavePdf();
    } else if (status.isDenied) {
      Dialogs.showSnackbarError(context, 'Permiso de almacenamiento denegado');
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _generateAndSavePdf() async {
    try {
      final pdf = await _generatePdf();
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/estudiantes.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdf);
      setState(() {
        localFilePath = filePath;
        isLoading = false;
      });
      Dialogs.showSnackbar(context, 'PDF descargado en: $localFilePath');
      _checkFileExists();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Dialogs.showSnackbarError(context, 'Error al generar el PDF: $e');
    }
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    int totalPages = 0;

    final ByteData leftLogoData = await rootBundle.load('assets/img/logo.png');
    final ByteData rightLogoData = await rootBundle.load('assets/img/cp.png');
    final Uint8List leftLogoBytes = leftLogoData.buffer.asUint8List();
    final Uint8List rightLogoBytes = rightLogoData.buffer.asUint8List();

    final String institutionEmail = 'www.uleam.edu.ec';

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          totalPages++;
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(pw.MemoryImage(leftLogoBytes),
                        width: 100, height: 100),
                    pw.Image(pw.MemoryImage(rightLogoBytes),
                        width: 50, height: 50),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Lista de Estudiantes',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  border: const pw.TableBorder(
                    horizontalInside: pw.BorderSide(color: PdfColors.red),
                    verticalInside: pw.BorderSide(color: PdfColors.red),
                    left: pw.BorderSide(color: PdfColors.red),
                    top: pw.BorderSide(color: PdfColors.red),
                    right: pw.BorderSide(color: PdfColors.red),
                    bottom: pw.BorderSide(color: PdfColors.red),
                  ),
                  headers: [
                    'Nombres',
                    'Apellidos',
                    'Cédula',
                    'Correo',
                    'Sexo',
                    'Edad'
                  ],
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                  data: widget.estudiantes
                      .map((estudiante) => [
                            estudiante.nombres,
                            estudiante.apellidos,
                            estudiante.cedula,
                            estudiante.correo,
                            estudiante.genero,
                            estudiante.edad
                          ])
                      .toList(),
                ),
              ],
            ),
          ];
        },
        footer: (pw.Context context) {
          return pw.Container(
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Fecha: $formattedDate'),
                pw.Text(institutionEmail),
                pw.Text('Página ${context.pageNumber}/$totalPages'),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  void _checkFileExists() async {
    if (localFilePath != null) {
      final file = File(localFilePath!);
      if (await file.exists()) {
        Dialogs.showSnackbar(
            context, 'PDF guardado correctamente en: $localFilePath');
      } else {
        Dialogs.showSnackbarError(
            context, 'No se encontró el archivo PDF en: $localFilePath');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista Previa del PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              if (localFilePath != null) {
                Dialogs.showSnackbar(
                    context, 'PDF descargado en: $localFilePath');
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : localFilePath != null
              ? PDFView(
                  filePath: localFilePath!,
                  onViewCreated: (controller) {
                    controller.setPage(0);
                  },
                  onRender: (pages) {
                    setState(() {});
                  },
                  onError: (error) {
                    Dialogs.showSnackbarError(
                        context, 'Error al mostrar el PDF: $error');
                  },
                  onPageError: (page, error) {
                    Dialogs.showSnackbarError(
                        context, 'Error en la página $page: $error');
                  },
                )
              : _buildPreviewTable(),
    );
  }

  Widget _buildPreviewTable() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(3),
            4: FlexColumnWidth(4),
            5: FlexColumnWidth(5),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                _buildTableCell('Nombres', isHeader: true),
                _buildTableCell('Apellidos', isHeader: true),
                _buildTableCell('Cédula', isHeader: true),
                _buildTableCell('Correo', isHeader: true),
                _buildTableCell('Género', isHeader: true),
                _buildTableCell('Edad', isHeader: true),
              ],
            ),
            ...widget.estudiantes.map((estudiante) {
              return TableRow(
                children: [
                  _buildTableCell(estudiante.nombres.toString()),
                  _buildTableCell(estudiante.apellidos.toString()),
                  _buildTableCell(estudiante.cedula.toString()),
                  _buildTableCell(estudiante.correo.toString()),
                  _buildTableCell(estudiante.genero.toString()),
                  _buildTableCell(estudiante.edad.toString()),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[300] : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 16 : 14,
        ),
      ),
    );
  }
}
