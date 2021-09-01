# flutter_exprtk

ffi wrapper for exprtk math expression parser

See https://github.com/ArashPartow/exprtk for details

## Limitations
Only works with doubles, not vectors etc.

Currently supports Android, MacOS, iOS, Web and Windows






## To install
    dependencies:
        flutter:
            sdk: flutter
        flutter_web_plugins: # for web support
            sdk: flutter     # for web support

        flutter_exprtk: ^0.0.6-dev.1

Import the library:

    import 'package:flutter_exprtk/flutter_exprtk.dart';


## Web Platform:
Web is supported by a wasm module, which has to be included manually and will only work in release mode.

You can find it in the git repository:

https://github.com/DominikStarke/flutter_exprtk/tree/web/wasm

* copy flutter_exprtk.wasm and flutter_exprtk.js to the root of your build output folder
* add <script src="flutter_exprtk.js"></script> to the index.html

if you want to compile the wasm module you can do so with emscripten:
```
emcc flutter_exprtk.cpp -s WASM=1 -o flutter_exptrk.js -s "EXPORTED_RUNTIME_METHODS=['cwrap', 'allocateUTF8OnStack']" -O3 -flto
```

Once you have everything set up start a "secure" webserver. The wasm directory holds a snakeoil cert and key for that purpose.

## Getting Started
    // Create a new expression
    final exp = Expression(
        expression: "a / b", // The expression
        variables: { "a": 4, "b": 2 }, // variables
        constants: {} // Optional constants can be omitted
    );

    // Get the value
    print(exp.value); // -> 2

    // Variables can be changed:
    exp["a"] = 100
    print(exp.value); // -> 50

    exp["b"] = 50
    print(exp.value); // -> 2

    // Call clear to free up memory
    expression.clear();


More complex example:

    final exp2 = Expression(
        expression: "clamp(-1.0,sin(2 * pi * x) + cos(x / 2 * pi),+1.0)",
        variables: { "x": 0 }
    );
    for (double x = -5; x <= 5; x += 0.001)
    {
        exp2["x"] = x;
        print("${exp2.value}");
    }
    // Call clear to free up memory
    exp2.clear();

In a separate Isolate:

    // Static or global function:
    Future<List<double>> computeExpression (dynamic _) async {
        final exp2 = Expression(
            expression: "clamp(-1.0,sin(2 * pi * x) + cos(x / 2 * pi),+1.0)",
            variables: { "x": 0 }
        );
        final List<double> results = [];

        for (double x = -5; x <= 5; x += 0.001)
        {
            exp2["x"] = x;
            results.add(exp2.value);
        }
        exp2.clear();

        return results;
    }

    // Then run it for example with compute from flutter:foundation:
    final results = await compute(computeExpression, null);
    print("Results $results");

## Handling errors

new Expression() will throw an "InvalidExpressionException" if the expression isn't valid.

If you try to set a variable which hasn't been initialized an "UninitializedVariableException" will be thrown:

    try {
        final exp = Expression(
            expression: "///////", // will cause an InvalidExpressionException
            variables: {}
        );

        final exp = Expression(
            expression: "a + b",
            variables: { "c": 0 } // will cause an UninitializedVariableException
        );
        exp["d"] = 0; // will also cause an UninitializedVariableException

    } on InvalidExpressionException {
        // ... handle exception
    } on UninitializedVariableException {
        // ... handle exception
    }

