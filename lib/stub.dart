import 'package:flutter_exprtk/flutter_exprtk.dart';

Expression getExpression(
        {required expression,
        required Map<String, double> variables,
        Map<String, double>? constants}) =>
    throw UnsupportedError(
        'Cannot create Expression on this platform: dart:html or dart:io required');
