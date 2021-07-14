
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {

  final _modelFile = 'feed.tflite';

  Map<String, int> _dict;


  Interpreter _interpreter;

  Classifier() {

    _loadModel();
  }

  void _loadModel() async {

    _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');
  }

  List<double> classify(List<double> ip) {

    print(ip);
    List<double> input = ip;
    List<double> results = new List<double>();
    var output = new List.generate(1, (_) => new List(1));
    List<double> temp = input;
    _interpreter.run(input, output);
    int i = 0;
    while (i < 7) {
      if (temp.length > 3) {
        input = temp.sublist(1, temp.length);
        _interpreter.run(input, output);
        temp.add(output[0][0]);
        temp = temp.sublist(1, temp.length);
        results.add(output[0][0]);
      } else {
        _interpreter.run(input, output);
        var r = output[0][0];
        temp.add(r);
        results.add(r);
      }
      i++;
    }
    print(results);
    return results;
  }
}


