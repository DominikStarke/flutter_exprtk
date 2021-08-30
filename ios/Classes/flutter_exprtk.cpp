#include "ext/exprtk/exprtk.hpp"
#include <map>

#ifdef WIN32
#define EXTERNC extern "C" __declspec( dllexport )
#else
#define EXTERNC extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

typedef exprtk::symbol_table<double> symbol_table_t;
typedef exprtk::expression<double>   expression_t;
typedef exprtk::parser<double>       parser_t;

using map_sd = std::map<std::string, double>;
using pair_sd = std::pair<std::string, double>;
using il_sd  = std::initializer_list<map_sd::value_type>;

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

class __Expression {
    public:
        std::string expression;
        double result;
        uint8_t isValid;

        std::shared_ptr<map_sd> variables;
        std::shared_ptr<map_sd> constants;
        std::shared_ptr<symbol_table_t> symbol_table;
        std::shared_ptr<parser_t> parser;
        std::shared_ptr<expression_t> exprtk;
};

EXTERNC void set_var(char* name, double value, std::shared_ptr<__Expression> expression) {
    auto res = expression->variables->insert(
        pair_sd(name, value));
    if (!res.second)
        res.first->second = value;
}

EXTERNC void set_const(char* name, double value, std::shared_ptr<__Expression> expression) {
    auto res = expression->constants->insert(
            pair_sd(name, value));
}

EXTERNC double get_var(char* name, std::shared_ptr<__Expression> expression) {
    return expression->variables->at(name);
}

EXTERNC double get_const(char* name, std::shared_ptr<__Expression> expression) {
    return expression->constants->at(name);
}

EXTERNC void parse_expression(std::shared_ptr<__Expression> expression) {
    expression->isValid = true;
    map_sd::iterator it;

    for (it = expression->variables->begin(); it != expression->variables->end(); it++)
    {
        expression->symbol_table->add_variable(
                it->first, it->second);
    }

    for (it = expression->constants->begin(); it != expression->constants->end(); it++)
    {
        expression->symbol_table->add_constant(
                it->first, it->second);
    }

    expression->symbol_table->add_constants();
    expression->exprtk->register_symbol_table(
        *expression->symbol_table);

    if (!expression->parser->compile(expression->expression, *expression->exprtk))
    {
        expression->isValid = false;
    }
}

EXTERNC void new_expression(Expression* exp) {

    auto result = std::make_shared<__Expression>();
    result->variables = std::make_shared<map_sd>();
    result->constants = std::make_shared<map_sd>();
    result->symbol_table = std::make_shared<symbol_table_t>();
    result->parser = std::make_shared<parser_t>();
    result->exprtk = std::make_shared<expression_t>();

    // result->expression = expression_string;
    // set_var(exp->variables[i]->name, exp->variables[i]->value, result);
    // parse_expression(result);
    // auto val = result->exprtk->value();

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
