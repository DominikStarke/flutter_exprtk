#include "ext/exprtk/exprtk.hpp"
#include <iostream>

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

class Expression {
    public:
        Expression(std::string expression_string) {
            std::cout << "New Expression" << std::endl;
            expression = expression_string;
        }

        ~Expression() {
            std::cout << "Destruct Expression" << std::endl;
        }

        void parse_expression() {
            isValid = true;
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
                isValid = false;
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

        uint8_t is_valid() {
            return isValid;
        }

    private:
        std::string expression;
        double result = 0.0;
        uint8_t isValid = false;

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

EXTERNC uint8_t is_valid(Expression* expression) {
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

