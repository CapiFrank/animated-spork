import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_cipher/utils/error_handler.dart';
import 'package:project_cipher/utils/pdf_settings.dart';

/// Modelo simple para parámetros de la factura
class PdfParams {
  final List<List<String>> supplier;
  final List<List<String>> customer;
  final List<List<String>> invoiceTable;
  final String title;
  final List<dynamic> columnsToSum;
  final String totalLabel;
  final Map<String, String> columnUnits; // 'Precio': '₡', 'Volumen': 'm³'

  PdfParams({
    required this.supplier,
    required this.customer,
    required this.invoiceTable,
    required this.title,
    this.columnsToSum = const [],
    this.totalLabel = 'Totales:',
    this.columnUnits = const {},
  });
}


class PdfInvoiceGenerator {
  static Future<void> build({
  required List<List<String>> supplier,
  required List<List<String>> customer,
  required List<List<String>> invoiceTable,
  String title = 'FACTURA',
  List<dynamic> columnsToSum = const [],
  String totalLabel = 'Totales:',
  Map<String, String> columnUnits = const {},
}) async {
  try {
    final params = PdfParams(
      supplier: supplier,
      customer: customer,
      invoiceTable: invoiceTable,
      title: title,
      columnsToSum: columnsToSum,
      totalLabel: totalLabel,
      columnUnits: columnUnits,
    );
    final file = await compute(_generatePdf, params);
    final pdf = await PdfSettings.saveDocument(name: 'invoice', pdf: file);
    PdfSettings.openFile(pdf);
  } catch (e) {
    ErrorHandler.handleError(e);
  }
}

}

/// Función top-level compatible con `compute()`
pw.Document _generatePdf(PdfParams params) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        _buildHeader(params),
        pw.SizedBox(height: 20),
        pw.Text(
          params.title,
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        _buildInvoiceTable(params.invoiceTable,params),
      ],
      footer: (pw.Context context) => _buildFooter(),
    ),
  );

  return pdf;
}

/// Construye cabecera con secciones Empresa y Cliente
pw.Widget _buildHeader(PdfParams p) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoSection('Empresa', p.supplier),
            _buildInfoSection('Cliente', p.customer),
          ],
        ),
      ],
    );

/// Muestra datos tipo ['Label:', 'valor']
pw.Widget _buildInfoSection(String title, List<List<String>> data) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        ...data.map((row) => _buildKeyValue(row[0], row[1])),
      ],
    );

/// Fila tipo: Etiqueta: Valor
pw.Widget _buildKeyValue(String key, String value) => pw.Wrap(
      children: [
        pw.Text('$key ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );

/// Construye tabla con encabezados dinámicos
pw.Widget _buildInvoiceTable(List<List<String>> table, PdfParams params) {
  if (table.isEmpty) return pw.Text('Sin datos');

  final headers = table.first;
  final dataRows = table.sublist(1);

  // Identificar columnas a sumar (índices)
  final Set<int> columnsToSum = {};
  for (var col in params.columnsToSum) {
    if (col is int && col >= 0 && col < headers.length) {
      columnsToSum.add(col);
    } else if (col is String) {
      final index = headers.indexOf(col);
      if (index != -1) columnsToSum.add(index);
    }
  }

  // Calcular totales
  final Map<int, double> totals = {for (var i in columnsToSum) i: 0.0};

  for (final row in dataRows) {
    for (final i in columnsToSum) {
      final value = double.tryParse(row[i]) ?? 0.0;
      totals[i] = totals[i]! + value;
    }
  }

  // Fila de totales
  final totalRow = List.generate(headers.length, (i) {
    if (totals.containsKey(i)) {
      // Buscar unidad por índice
      String? unit;
      final colName = headers[i];
      unit = params.columnUnits[colName]; // puede ser '₡', 'm³', etc.
      final formatted = totals[i]!.toStringAsFixed(2);
      return unit != null ? '$unit $formatted' : formatted;
    } else if (i == 0) {
      return params.totalLabel;
    } else {
      return '';
    }
  });

  final dataWithTotals = [...dataRows, totalRow];

  return pw.TableHelper.fromTextArray(
    headers: headers,
    data: dataWithTotals,
    border: null,
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
    cellHeight: 30,
    cellAlignments: {
      for (int i = 0; i < headers.length; i++) i: pw.Alignment.centerLeft,
    },
    cellStyle: pw.TextStyle(fontSize: 10),
    cellDecoration: (rowIndex, columnIndex, cellData) {
      final isTotalRow = rowIndex == dataWithTotals.length - 1;
      if (isTotalRow) {
        return pw.BoxDecoration(color: PdfColors.grey200);
      }
      return pw.BoxDecoration();
    },
  );
}


/// Footer genérico
pw.Widget _buildFooter() => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Gracias por su compra', style: pw.TextStyle(fontSize: 12)),
      ],
    );
