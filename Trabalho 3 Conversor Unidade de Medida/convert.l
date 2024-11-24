%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "convert.tab.h"
%}

%%

[0-9]+(\.[0-9]+)?[ \t]*[a-zA-Z/]+[ \t]+to[ \t]+[a-zA-Z/]+ {
    yylval.str = strdup(yytext);
    return CONVERT_CMD;
}

[ \t]+      { /* Ignorar espaços e tabulações extras */ }
\n          { return ENDL; }
.           { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
