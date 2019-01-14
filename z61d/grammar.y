%{

%}
%union {
	int ival;
	float fval;
}
%start plik
%token UNDEFINED NL
%token <ival> DECIMAL HEX INDEX
%token <fval> FIXED FLOAT_E
%type <ival> dec hex
%type <fval> fixed float_e
%%

plik:
|     plik wiersz;

wiersz:  NL
|       INDEX dec NL { LOG("Linika z liczbami calkowitymi\n"); printf("%d %d\n", $1, $2); }
|       INDEX hex NL { LOG("Linika z liczbami haksadecymalnymi\n"); printf("%d %#x\n", $1, $2); }
|       INDEX fixed NL { LOG("Linika z liczbami staloprzecinkowymi\n"); printf("%d %f\n", $1, $2); }
|       INDEX float_e NL { LOG("Linika z liczbami zmiennoprzecinkowymi\n"); printf("%d %E\n", $1, $2); };

dec: DECIMAL { $$ = $1; }
|    dec DECIMAL { $$ = $1 + $2; };

hex: HEX { $$ = $1; }
|    hex HEX { $$ = $1 + $2; };

fixed: FIXED { $$ = $1; }
|      FIXED fixed { $$ = $1 + $2; };

float_e: FLOAT_E { $$ = $1; }
|        float_e FLOAT_E { $$ = $1 + $2; };

%%

int yyerror(char* errstr) {
	printf("error: %s\n", errstr);
}
int yywrap(){ return 0; };
int yylex();
int main() {
	yyparse();
	return 0;
}