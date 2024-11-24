%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <locale.h>

void convert_units(const char *input);
int yylex();
void yyerror(const char *s);
%}

%union {
    char *str;
}

%token <str> CONVERT_CMD
%token ENDL

%%

commands:
    command ENDL commands
    | command ENDL
    ;

command:
    CONVERT_CMD {
        convert_units($1);
        free($1);
    }
    ;

%%

void convert_units(const char *input) {
    double value;
    char from_unit[50], to_unit[50];

    if (sscanf(input, "%lf%49s to %49s", &value, from_unit, to_unit) != 3) {
        printf("Erro: comando invalido. Use o formato <valor><unidade_origem> to <unidade_destino>\n");
        return;
    }

    if (strcmp(from_unit, "m") == 0 && strcmp(to_unit, "km") == 0) {
        printf("%.2lf m = %.2lf km\n", value, value / 1000.0);
    } else if (strcmp(from_unit, "km") == 0 && strcmp(to_unit, "m") == 0) {
        printf("%.2lf km = %.2lf m\n", value, value * 1000.0);
    } else if (strcmp(from_unit, "kg") == 0 && strcmp(to_unit, "g") == 0) {
        printf("%.2lf kg = %.2lf g\n", value, value * 1000.0);
    } else if (strcmp(from_unit, "g") == 0 && strcmp(to_unit, "kg") == 0) {
        printf("%.2lf g = %.2lf kg\n", value, value / 1000.0);
    } else if (strcmp(from_unit, "s") == 0 && strcmp(to_unit, "min") == 0) {
        printf("%.2lf s = %.2lf min\n", value, value / 60.0);
    } else if (strcmp(from_unit, "min") == 0 && strcmp(to_unit, "s") == 0) {
        printf("%.2lf min = %.2lf s\n", value, value * 60.0);
    } else if (strcmp(from_unit, "C") == 0 && strcmp(to_unit, "F") == 0) {
        printf("%.2lf C = %.2lf F\n", value, (value * 9.0 / 5.0) + 32.0);
    } else if (strcmp(from_unit, "F") == 0 && strcmp(to_unit, "C") == 0) {
        printf("%.2lf F = %.2lf C\n", value, (value - 32.0) * 5.0 / 9.0);
    } else if (strcmp(from_unit, "m/s") == 0 && strcmp(to_unit, "km/h") == 0) {
        printf("%.2lf m/s = %.2lf km/h\n", value, value * 3.6);
    } else if (strcmp(from_unit, "km/h") == 0 && strcmp(to_unit, "m/s") == 0) {
        printf("%.2lf km/h = %.2lf m/s\n", value, value / 3.6);
    } else if (strcmp(from_unit, "L") == 0 && strcmp(to_unit, "ml") == 0) {
        printf("%.2lf L = %.2lf ml\n", value, value * 1000.0);
    } else if (strcmp(from_unit, "ml") == 0 && strcmp(to_unit, "L") == 0) {
        printf("%.2lf ml = %.2lf L\n", value, value / 1000.0);
    } else {
        printf("Erro: conversão de '%s' to '%s' não suportada.\n", from_unit, to_unit);
    }
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main() {
    setlocale(LC_ALL, ""); // Corrige problemas de acentuação no Windows
    printf("Digite comandos no formato: <valor><unidade_origem> to <unidade_destino>\n");
    printf("Pressione CTRL+D (Linux/Mac) ou CTRL+C (Windows) para sair.\n");

    while (!feof(stdin)) {
        yyparse();
    }

    return 0;
}
