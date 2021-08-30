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

    final exp = Expression(
      expression: "a / b",
      variables: { "a": 4, "b": 2 }
    );
    print(exp.value); // 4/2=2

    exp["a"] = 100;
    exp["b"] = 300;
    print(exp.value); // 100/300=0.333333...
    
    final exp2 = Expression(
      expression: "clamp(-1.0,sin(2 * pi * x) + cos(x / 2 * pi),+1.0)",
      variables: { "x": 0 }
    );
    for (double x = -5; x <= 5; x += 0.001)
    {
      exp2["x"] = x;
      print("${exp2.value}");
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Expression plugin example'),
        ),
        body: Center(
          child: Text('Running'),
        ),
      ),
    );
  }
}
