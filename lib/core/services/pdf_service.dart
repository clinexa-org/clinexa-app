import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../app/theme/app_colors.dart';

class PdfService {
  /// Generates a PDF for a prescription and returns the bytes.
  Future<Uint8List> generatePrescriptionPdf({
    required String prescriptionId,
    required String date,
    required String doctorName,
    required List<Map<String, dynamic>> medicines,
    required String notes,
  }) async {
    final doc = pw.Document();

    // Load a font if necessary, otherwise use standard fonts
    // final font = await PdfGoogleFonts.interRegular();
    // final fontBold = await PdfGoogleFonts.interBold();

    // Define colors using the app theme colors (converted to PdfColor)
    final PdfColor primaryColor = _toPdfColor(AppColors.primary);
    final PdfColor accentColor = _toPdfColor(AppColors.accent);
    final PdfColor textColor = _toPdfColor(AppColors.textPrimary);
    final PdfColor textSecondaryColor = _toPdfColor(AppColors.textSecondary);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(
                prescriptionId, date, primaryColor, textSecondaryColor),
            pw.SizedBox(height: 20),
            _buildDoctorInfo(doctorName, textColor),
            pw.SizedBox(height: 20),
            _buildMedicinesTable(medicines, primaryColor, textColor),
            if (notes.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              _buildNotesSection(notes, accentColor, textColor),
            ],
            pw.SizedBox(height: 40),
            _buildFooter(textSecondaryColor),
          ];
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(
      String id, String date, PdfColor primary, PdfColor secondary) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'CLINEXA',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: primary,
              ),
            ),
            pw.Text(
              'Prescription',
              style: pw.TextStyle(
                fontSize: 18,
                color: secondary,
              ),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('ID: #$id', style: pw.TextStyle(color: secondary)),
            pw.Text('Date: $date', style: pw.TextStyle(color: secondary)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDoctorInfo(String doctorName, PdfColor textColor) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        children: [
          pw.Text(
            'Doctor: ',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: textColor,
            ),
          ),
          pw.Text(
            doctorName,
            style: pw.TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMedicinesTable(List<Map<String, dynamic>> medicines,
      PdfColor primary, PdfColor textColor) {
    final headers = ['Medicine', 'Dosage', 'Type', 'Duration', 'Instructions'];
    final data = medicines.map((m) {
      return [
        m['name'] ?? '',
        m['dosage'] ?? '',
        m['type'] ?? 'Tablet',
        m['duration'] ?? '-',
        m['instructions'] ?? '-', // Assuming instruction might be there or not
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle:
          pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: pw.BoxDecoration(color: primary),
      cellStyle: pw.TextStyle(fontSize: 10, color: textColor),
      cellPadding: const pw.EdgeInsets.all(8),
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerAlignment: pw.Alignment.centerLeft,
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  pw.Widget _buildNotesSection(
      String notes, PdfColor accent, PdfColor textColor) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        // borderRadius: pw.BorderRadius.circular(8), // Removed to avoid conflict with non-uniform border
        border: pw.Border(left: pw.BorderSide(color: accent, width: 4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Doctor\'s Notes:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: accent),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            notes,
            style: pw.TextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(PdfColor secondary) {
    return pw.Center(
      child: pw.Text(
        'Generated by Clinexa App',
        style: pw.TextStyle(
            fontSize: 10, color: secondary, fontStyle: pw.FontStyle.italic),
      ),
    );
  }

  /// Helper to convert Color to PdfColor
  PdfColor _toPdfColor(dynamic color) {
    // Handling standard flutter Color
    if (color is Color) {
      return PdfColor.fromInt(color.value);
    }
    // Fallback if something else is passed
    return PdfColors.black;
  }
}
