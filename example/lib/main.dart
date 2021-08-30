import 'package:flutter/material.dart';
import 'package:flutter_exprtk/expression.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
            onPressed: () {

              final exp2 = Expression(
                expression: "clamp(-1.0,sin(2 * pi * x) + cos(x / 2 * pi),+1.0)",
                variables: { "x": 0 }
              );

              final stopwatch = Stopwatch()..start();
              for (double x = -5; x <= 5; x += 0.001)
              {
                exp2["x"] = x;
                exp2.value;
                // print("${exp2.value}");
              }
              print('Execution took ${stopwatch.elapsed.inMicroseconds} microseconds');

            },
            child: Text("Run"),
          )
        ),
      ),
    );
  }
}
