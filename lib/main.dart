import 'package:flutter/material.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromARGB(255, 32, 82, 231),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _nameController = TextEditingController();
  String _printedName = '';
  PosTextSize _selectedFontSize = PosTextSize.size1;

  Future<void> _print(String text, PosStyles style) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res =
        await printer.connect('192.168.1.100', port: 9100);
    if (res != PosPrintResult.success) {
      print('Could not connect to printer.');
      return;
    }

    printer.text(text, styles: style);

    printer.cut();
    printer.disconnect();
  }

  Map<PosTextSize, String> _fontSizeLabels = {
    PosTextSize.size1: 'Font Size 1',
    PosTextSize.size2: 'Font Size 2',
    PosTextSize.size3: 'Font Size 3',
    PosTextSize.size4: 'Font Size 4',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'POS Printer App',
            style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 300, top: 20.0, bottom: 20),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Printed Name:',
                    style: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: _fontSizeLabels.entries.map<Widget>(
              (MapEntry<PosTextSize, String> entry) {
                return Text(
                  _printedName, // Display the printed name here
                  style: TextStyle(
                    fontSize: entry.key == PosTextSize.size1
                        ? 18
                        : entry.key == PosTextSize.size2
                            ? 20
                            : entry.key == PosTextSize.size3
                                ? 24
                                : entry.key == PosTextSize.size4
                                    ? 28
                                    : 18,
                  ),
                );
              },
            ).toList(),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 50,
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 34, 26, 116),
                    ),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        contentPadding: EdgeInsets.fromLTRB(10, 2, 5, 16),
                        hintStyle: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 13),
                        border: InputBorder.none,
                        fillColor: Color.fromARGB(255, 240, 231, 231),
                        prefixIconConstraints:
                            BoxConstraints(maxHeight: 20, maxWidth: 40),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      String name = _nameController.text.isNotEmpty
                          ? _nameController.text
                          : '';
                      _print(
                        name,
                        PosStyles(
                          align: PosAlign.left,
                          height: _selectedFontSize,
                          width: PosTextSize.size1,
                        ),
                      );
                      setState(() {
                        _printedName = name;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 34, 26, 116),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Print Name',
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 50,
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 34, 26, 116),
      ),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          // filled: true,
          // alignLabelWithHint: true,
          hintText: 'Enter your name',
          contentPadding: EdgeInsets.fromLTRB(10, 2, 5, 16),
          hintStyle: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.w300, color: Colors.white, fontSize: 13),
          border: InputBorder.none,
          fillColor: Color.fromARGB(255, 240, 231, 231),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 40),
        ),
      ),
    );
  }
}
