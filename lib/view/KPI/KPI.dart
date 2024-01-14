import 'package:destask/utils/global_colors.dart';
import 'package:flutter/material.dart';

class KPI extends StatefulWidget {
  @override
  _KPIState createState() => _KPIState();
}

class _KPIState extends State<KPI> {
  final List<DataRow> kpiDataRows = [
    DataRow(cells: [
      DataCell(Text('Januari', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('2022', style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text('90', style: TextStyle(fontWeight: FontWeight.bold))),
    ]),
    DataRow(cells: [
      DataCell(Text('Februari')),
      DataCell(Text('2022')),
      DataCell(Text('85')),
    ]),
    DataRow(cells: [
      DataCell(Text('Maret')),
      DataCell(Text('2022')),
      DataCell(Text('92')),
    ]),
    // Tambahkan baris lain sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        title: Text('KPI'),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: FittedBox(
            fit: BoxFit.contain,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minWidth: MediaQuery.of(context).size.width),
              child: DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.cyan),
                headingTextStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                columnSpacing: 16,
                columns: [
                  DataColumn(label: Text('Bulan')),
                  DataColumn(label: Text('Tahun')),
                  DataColumn(label: Text('Skor')),
                ],
                rows: kpiDataRows,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
