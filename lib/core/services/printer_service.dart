import 'dart:io';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrinterService {
  static Future<void> printBill(Map<String, dynamic> billData) async {
    final pdf = await _generateBillPdf(billData);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static Future<void> shareBill(Map<String, dynamic> billData) async {
    final pdf = await _generateBillPdf(billData);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'bill_${billData['orderNumber']}.pdf',
    );
  }

  static Future<pw.Document> _generateBillPdf(Map<String, dynamic> billData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'RESTAURANT BILL',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Order #: ${billData['orderNumber']}'),
              pw.Text('Date: ${billData['date']}'),
              pw.Text('Customer: ${billData['customerName'] ?? 'Walk-in'}'),
              pw.Text('Table: ${billData['tableNumber'] ?? 'N/A'}'),
              pw.Divider(),
              pw.Text('ITEMS:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              ...billData['items'].map<pw.Widget>((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${item['quantity']} x ${item['name']}'),
                    pw.Text('₹${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                  ],
                );
              }).toList(),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:'),
                  pw.Text('₹${billData['subtotal'].toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tax (18%):'),
                  pw.Text('₹${billData['tax'].toStringAsFixed(2)}'),
                ],
              ),
              if (billData['discount'] > 0) pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Discount:'),
                  pw.Text('-₹${billData['discount'].toStringAsFixed(2)}'),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    '₹${billData['total'].toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('Payment Method: ${billData['paymentMethod']}'),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Thank you for your visit!',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}