// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controllers/auth_controller.dart';
import '../../../models/medication_history.dart';
import '../../../themes/livi_theme.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/utils.dart';

String svgRaw = '''
<svg width="20" height="21" viewBox="0 0 20 21" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.71382 2.39058C5.72401 1.68859 6.256 1.10634 6.95631 1.05667C7.7293 1.00184 8.79323 0.944943 9.92507 0.94012C11.0834 0.935185 12.1963 0.995055 12.998 1.05369C13.6945 1.10463 14.2226 1.68359 14.2347 2.38182L14.524 19.0631C14.5375 19.8396 13.9117 20.4764 13.135 20.4764H6.86104C6.08591 20.4764 5.46071 19.8421 5.47195 19.067L5.71382 2.39058Z" fill="#667085"/>
<rect x="5.21307" y="14.4911" width="9.57385" height="0.694618" fill="#F2F4F7"/>
<path d="M7.62238 18.2446C7.62238 18.8065 8.07785 19.2619 8.63971 19.2619H11.3604C11.9222 19.2619 12.3777 18.8065 12.3777 18.2446C12.3777 18.0717 12.2376 17.9316 12.0647 17.9316H7.9354C7.76252 17.9316 7.62238 18.0717 7.62238 18.2446Z" fill="#F2F4F7"/>
</svg>
''';

final svgImage = pw.SvgImage(svg: svgRaw, height: 120);
final dateFormat = DateFormat('MM/dd');

class HistoryPdf {
  static String getDateTime(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return '${dateFormat.format(dateTime)} ${formartTimeOfDay(TimeOfDay(
          hour: dateTime.hour,
          minute: dateTime.minute,
        ), Provider.of<AuthController>(context, listen: false).appUser!.useMilitaryTime)}';
  }

  static pw.Widget getOutcome(MedicationHistory history) {
    if (history.outcome != null) {
      return pw.Text(history.outcome!.name.capitalizeFirstLetter());
    } else {
      return pw.SizedBox();
    }
  }

  static Future<pw.MultiPage> historyPDF(
      {required List<MedicationHistory> medicationHistory,
      required BuildContext buildContext}) async {
    Map<int, pw.TableColumnWidth> widths = Map();
    widths = {
      0: pw.FractionColumnWidth(0.1),
      1: pw.FractionColumnWidth(0.235),
      2: pw.FractionColumnWidth(0.1),
      3: pw.FractionColumnWidth(0.11),
      4: pw.FractionColumnWidth(0.235),
      5: pw.FractionColumnWidth(0.1),
      6: pw.FractionColumnWidth(0.12),
    };
    return pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.natural,
        margin: pw.EdgeInsets.all(30),
        header: (context) => pw.Header(
            level: 0,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Center(
                    child: svgImage,
                  ),
                  pw.Text(
                    'Medication History',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 40)
                ])),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Table(
                columnWidths: widths,
                // border: pw.TableBorder.all(color: PdfColors.indigo),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(repeat: true, children: [
                    pw.Text(
                      'Date',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Name',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Quantity',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Outcome',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Schedule',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Due Time',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Remaining',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ]),
                  for (var history in medicationHistory)
                    pw.TableRow(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                              bottom: pw.BorderSide(color: PdfColors.grey)),
                        ),
                        children: [
                          pw.Text(getDateTime(buildContext, history.dateTime)),
                          pw.Text(history.getNameStrengthDosageForm()),
                          pw.Text(history.qtyDispensed.toInt().toString()),
                          getOutcome(history),
                          pw.Text(history.schedules ?? ''),
                          pw.Text(getDateTime(
                              buildContext, history.scheduledDosingTime)),
                          pw.Text(history.qtyRemaining.toInt().toString(),
                              textAlign: pw.TextAlign.center),
                        ]),
                ]),
          ];
        });
  }
}
