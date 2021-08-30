
import 'package:ffi/ffi.dart';
import 'dart:ffi';
import 'dart:io';

class Variable extends Struct {
  Pointer<Utf8>? name;
  @Double()
  double? value;
}

class ExpressionStruct extends Struct {
  Pointer<Utf8>? expression;
  Pointer<Pointer<Variable>>? variables;
  @Int32()
  int? numVariables;
  Pointer<Pointer<Variable>>? constants;
  @Int32()
  int? numConstants;
  @Double()
  double? result;
  @Uint8()
  int? isValid;
  Pointer? exprtk;
}

typedef NewExpressionImpl = Void Function(Pointer<ExpressionStruct>);
typedef NewExpression = void Function(Pointer<ExpressionStruct>);

typedef GetValueImpl = Float Function(Pointer<ExpressionStruct>);
typedef GetValue = double Function(Pointer<ExpressionStruct>);

class NativeExpression {
  static bool _initialized = false;
  static late final NewExpression _newExpression;
  static late final GetValue getValue;

  static init() {
    if(_initialized) return;

    final DynamicLibrary expressionLib = 
        Platform.isAndroid ? DynamicLibrary.open("libflutter_exprtk.so")
      : Platform.isWindows ? DynamicLibrary.open("flutter_exprtk_plugin.dll")
      : DynamicLibrary.process();

    _newExpression = expressionLib
      .lookup<NativeFunction<NewExpressionImpl>>("new_expression")
      .asFunction();

    getValue = expressionLib
      .lookup<NativeFunction<GetValueImpl>>("get_value")
      .asFunction();
    
    _initialized = true;
  }

  static Pointer<ExpressionStruct> newExpression({
    required String expression,
    required Map<String, double> variables,
    Map<String, double>? constants
  }) {

    final pExpression = malloc<ExpressionStruct>();
    pExpression.ref.expression = expression.toNativeUtf8();
    pExpression.ref.variables = malloc.allocate<Pointer<Variable>>(variables.length);

    pExpression.ref.numVariables = variables.length;
    int varNum = 0;
    variables.forEach((name, value) {
      final pVariable = malloc<Variable>();

      pVariable.ref.name = name.toNativeUtf8();
      pVariable.ref.value = value;

      pExpression.ref.variables!.elementAt(varNum).value = pVariable;
      varNum++;
    });


    pExpression.ref.numConstants = constants?.length ?? 0;
    if(constants != null) {
      pExpression.ref.variables = malloc.allocate<Pointer<Variable>>(constants.length);
      
      int constNum = 0;
      constants.forEach((name, value) {
        final pConstant = malloc<Variable>();

        pConstant.ref.name = name.toNativeUtf8();
        pConstant.ref.value = value;

        pExpression.ref.constants!.elementAt(constNum).value = pConstant;
        constNum++;
      });
    }

    _newExpression(pExpression);
    if(pExpression.ref.isValid == 0) {
      throw 'Invalid expression';
    }

    return pExpression;
  }

}
