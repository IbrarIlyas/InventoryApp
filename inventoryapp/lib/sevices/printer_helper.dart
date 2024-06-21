import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' show TableHelper;
import '../Model/item_class.dart';

class PrinterHelper {
  static Future<void> printReceipt(List<Item> cartItems,double subTotal) async {
    final pdf = pw.Document();
    final date = DateTime.now();
    final dateString = "${date.day}-${date.month}-${date.year} \t\t${date.hour}:${date.minute}:${date.second}";
    final receiptFormat = PdfPageFormat(
      36 * PdfPageFormat.inch,
      36 * PdfPageFormat.inch,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Receipt', style: pw.TextStyle(fontSize: 24)),
              pw.Text('Date: $dateString', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Item', 'Price', 'Quantity'],
                  ...cartItems.map((item) => [item.name, item.price, item.quantity]),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total: ${subTotal}',
                style: pw.TextStyle(fontSize: 18),
              ),

            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
