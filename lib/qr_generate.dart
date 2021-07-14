import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';


class GeneratePage extends StatefulWidget {
  final String _tid;
  GeneratePage(this._tid);
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Data'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: QrImage(
              data: "abc",
              //data: widget._tid,
            ),
          ),
        ));
  }
}

String dummyData;

TextEditingController qrTextController = TextEditingController();
