import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exprtk/flutter_exprtk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static Future<List<double>> computeExpression(dynamic param) async {

    try {
      final exp2 = Expression(
          expression: "clamp(-1.0,sin(2 * pi * x) + cos(x / 2 * pi),+1.0)",
          variables: {"x": 0});
      final List<double> results = [];

      for (double x = -5; x <= 5; x += 0.001) {
        exp2["x"] = x;
        results.add(exp2.value);
      }
      exp2.clear();
      return results;
    } catch(e) {
      print("ERROR : INVALID");
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Expression plugin example'),
        ),
        body: Center(
            child: OutlinedButton(
          onPressed: () async {
            final results = await compute(computeExpression, null);
            print("Results $results");
          },
          child: Text("Run"),
        )),
      ),
    );
  }
}
