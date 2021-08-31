#include "ext/exprtk/exprtk.hpp"

#ifdef WIN32
#define EXTERNC extern "C" __declspec( dllexport )
#elif __EMSCRIPTEN__
#include <emscripten/emscripten.h>
#define PASTE(x) x
#define EXTERNC extern "C" EMSCRIPTEN_KEEPALIVE
#else
#define EXTERNC extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

using symbol_table_t = exprtk::symbol_table<double>;
using expression_t   = exprtk::expression<double>;
using parser_t       = exprtk::parser<double>;
using map_sd         = std::map<std::string, double>;
using pair_sd        = std::pair<std::string, double>;

class Expression {
    public:
        Expression(std::string expression_string) {
            expression = expression_string;
        }

        void parse_expression() {
            isValid = 1;
            map_sd::iterator it;

            for (it = variables.begin(); it != variables.end(); it++)
            {
                symbol_table.add_variable(
                        it->first, it->second);
            }

            for (it = constants.begin(); it != constants.end(); it++)
            {
                symbol_table.add_constant(
                        it->first, it->second);
            }

            symbol_table.add_constants();
            exprtk.register_symbol_table(symbol_table);

            if (!parser.compile(expression, exprtk))
            {
                isValid = 0;
            }
        }

        void set_var(const char* name, double value) {
            auto res = variables.insert(
                pair_sd(name, value));
            if (!res.second)
                res.first->second = value;
        }

        void set_const(const char* name, double value) {
            auto res = constants.insert(
                    pair_sd(name, value));
        }

        double get_var(const char* name) {
            return variables.at(name);
        }

        double get_const(const char* name) {
            return constants.at(name);
        }

        double get_result() {
            return exprtk.value();
        }

        int is_valid() {
            return isValid;
        }

    private:
        std::string expression;
        double result = 0.0;
        int isValid = 0;

        map_sd variables;
        map_sd constants;
        symbol_table_t symbol_table;
        parser_t parser;
        expression_t exprtk;
};

EXTERNC void set_var(const char* name, double value, Expression* expression) {
    expression->set_var(name, value);
}

EXTERNC void set_const(const char* name, double value, Expression* expression) {
    expression->set_const(name, value);
}

EXTERNC double get_var(const char* name, Expression* expression) {
    return expression->get_var(name);
}

EXTERNC double get_const(const char* name, Expression* expression) {
    return expression->get_const(name);
}

EXTERNC double get_result(Expression* expression) {
    return expression->get_result();
}

EXTERNC int is_valid(Expression* expression) {
    return expression->is_valid();
}

EXTERNC void parse_expression(Expression* expression) {
    expression->parse_expression();
}

EXTERNC Expression* new_expression(const char* expression_string) {
    return new Expression(expression_string);
}

EXTERNC void destruct_expression(Expression* expression) {
    delete expression;
}

