import 'dart:ffi';

/// Definition for Function lookup
/// see _newExpression
typedef NewExpressionImpl = IntPtr Function(IntPtr);

/// Definition for Function lookup
/// see _newExpression
typedef NewExpression = int Function(int);

/// Definition for Function lookup
/// see destructExpression
typedef DestructExpressionImpl = Void Function(IntPtr);

/// Definition for Function lookup
/// see destructExpression
typedef DestructExpression = void Function(int);

/// Definition for Function lookup
/// see _parseExpression
typedef ParseExpressionImpl = Void Function(IntPtr);

/// Definition for Function lookup
/// see _parseExpression
typedef ParseExpression = void Function(int);

/// Definition for Function lookup
/// see getValue
typedef GetValueImpl = Double Function(IntPtr);

/// Definition for Function lookup
/// see getValue
typedef GetValue = double Function(int);

/// Definition for Function lookup
/// see setVar and setConst
typedef SetVarOrConstImpl = Void Function(IntPtr, Double, IntPtr);

/// Definition for Function lookup
/// see setVar and setConst
typedef SetVarOrConst = void Function(int, double, int);

/// Definition for Function lookup
/// see getVar and getConst
typedef GetVarOrConstImpl = Double Function(IntPtr, IntPtr);

/// Definition for Function lookup
/// see getVar and getConst
typedef GetVarOrConst = double Function(int, int);

/// Definition for Function lookup
/// see isValid
typedef IsValidImpl = Uint8 Function(IntPtr);

/// Definition for Function lookup
/// see isValid
typedef IsValid = int Function(int);