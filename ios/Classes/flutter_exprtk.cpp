#include "ext/exprtk/exprtk.hpp"

#ifdef WIN32
#define EXTERNC extern "C" __declspec( dllexport )
#else
#define EXTERNC extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

typedef exprtk::symbol_table<double> symbol_table_t;
typedef exprtk::expression<double>   expression_t;
typedef exprtk::parser<double>       parser_t;

struct Variable {
    char* name;
    double value;
};

struct Expression {
    char* expression;
    Variable** variables;
    int numVariables;
    Variable** constants;
    int numConstants;
    double result;
    uint8_t isValid;
    expression_t* exprtk;
};

EXTERNC void new_expression(Expression* exp) {
    std::string expression_string = exp->expression;

    symbol_table_t symbol_table;

    for(int i=0; i<exp->numVariables; i++) {
        symbol_table.add_variable(
                exp->variables[i]->name, exp->variables[i]->value);
    }

    for(int i=0; i<exp->numConstants; i++) {
        symbol_table.add_constant(
                exp->constants[i]->name, exp->constants[i]->value);
    }

    symbol_table.add_constants();

    expression_t* expression = new expression_t();
    expression->register_symbol_table(symbol_table);

    parser_t parser;

    exp->isValid = true;
    if (!parser.compile(expression_string, *expression))
    {
        exp->isValid = false;
    }

    exp->exprtk = expression;
}

EXTERNC double get_value(Expression* exp) {
    auto value = exp->exprtk->value();
    return value;
}
