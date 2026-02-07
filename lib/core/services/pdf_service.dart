import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../app/theme/app_colors.dart';
import '../localization/app_localizations.dart';

class PdfService {
  /// Generates a PDF for a prescription and returns the bytes.
  Future<Uint8List> generatePrescriptionPdf({
    required String prescriptionId,
    required String date,
    required String doctorName,
    required List<Map<String, dynamic>> medicines,
    required String notes,
    required AppLocalizations localizations,
  }) async {
    final doc = pw.Document();

    // Load fonts with Unicode support (Cairo supports Arabic + Latin + symbols)
    final fontRegular = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    // Define colors using the app theme colors (converted to PdfColor)
    final PdfColor primaryColor = _toPdfColor(AppColors.primary);
    final PdfColor accentColor = _toPdfColor(AppColors.accent);
    final PdfColor textColor = _toPdfColor(AppColors.textPrimary);
    final PdfColor textSecondaryColor = _toPdfColor(AppColors.textSecondary);

    final isRTL = localizations.isRTL;
    final textDirection = isRTL ? pw.TextDirection.rtl : pw.TextDirection.ltr;

    // Create theme with Cairo font for full Unicode support (Arabic + symbols)
    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontRegular, // Cairo doesn't have italic, fallback to regular
      boldItalic: fontBold,
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        textDirection: textDirection,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(prescriptionId, date, primaryColor, textSecondaryColor,
                localizations),
            pw.SizedBox(height: 20),
            _buildDoctorInfo(doctorName, textColor, localizations),
            pw.SizedBox(height: 20),
            _buildMedicinesTable(
                medicines, primaryColor, textColor, localizations),
            if (notes.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              _buildNotesSection(notes, accentColor, textColor, localizations),
            ],
            pw.SizedBox(height: 40),
            _buildFooter(textSecondaryColor, localizations),
          ];
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(String id, String date, PdfColor primary,
      PdfColor secondary, AppLocalizations localizations) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              localizations.translate('app_name'),
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: primary,
              ),
            ),
            pw.Text(
              localizations.translate('label_prescription_title'),
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
            pw.Text('${localizations.translate('label_id')}: #$id',
                style: pw.TextStyle(color: secondary)),
            pw.Text('${localizations.translate('label_date')}: $date',
                style: pw.TextStyle(color: secondary)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDoctorInfo(
      String doctorName, PdfColor textColor, AppLocalizations localizations) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        children: [
          pw.Text(
            '${localizations.translate('label_doctor')}: ',
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
      PdfColor primary, PdfColor textColor, AppLocalizations localizations) {
    final headers = [
      localizations.translate('label_medicine'),
      localizations.translate('label_dosage'),
      localizations.translate('label_type'),
      localizations.translate('label_duration'),
      localizations.translate('label_instructions')
    ];
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

  pw.Widget _buildNotesSection(String notes, PdfColor accent,
      PdfColor textColor, AppLocalizations localizations) {
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
            localizations.translate('label_doctors_notes'),
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

  pw.Widget _buildFooter(PdfColor secondary, AppLocalizations localizations) {
    return pw.Center(
      child: pw.Text(
        localizations.translate('msg_generated_by'),
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
