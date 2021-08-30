# flutter_exprtk

ffi wrapper for exprtk math expression parser

See https://github.com/ArashPartow/exprtk for details

## To install
    dependencies:
    flutter:
        sdk: flutter

    flutter_exprtk:
        git:
            url: git@github.com:DominikStarke/flutter_exprtk.git


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

    exp["b] = 50
    print(exp.value); // -> 2


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

## Limitations
Only works with doubles, not vectors etc.

Currently supports Android, MacOS, iOS and Windows