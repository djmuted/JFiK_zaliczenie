%{
#include "string.h"
#include "grammar.tab.c"
int yyparse();
int yywrap();
%}

%%
"PRINT" return PRINT;
"WHILE" return WHILE;
"IF" return IF;
"++" return INCREMENT;
"--" return DECREMENT;
(<=|>=|==|!=|>|<) { 
	yylval.vName = (char*)malloc(strlen(yytext));
    strcpy (yylval.vName, yytext);
	return COND;
}
[a-z]+ {
	yylval.vName = (char*)malloc(strlen(yytext));
    strcpy (yylval.vName, yytext);
	return ZMIENNA;
}
[0-9]+ {
	yylval.iValue = atoi(yytext);
	return LICZBA;
	}
[+\-*^/=;] {
	return yytext[0];
	}
[ \t\n] ;
.	{
	return UNK;
	}
%%