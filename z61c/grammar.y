%{

%}
%union {
	int ival;
	float fval;
}
%start plik
%token UNDEFINED NL
%token <ival> DECIMAL HEX
%token <fval> FIXED FLOAT_E
%type <ival> dec hex
%type <fval> fixed float_e
%%

plik:
|     plik wiersz;

wiersz:  NL
|       dec NL { LOG("Linika z liczbami calkowitymi\n"); printf("%d\n", $1); }
|       hex NL { LOG("Linika z liczbami haksadecymalnymi\n"); printf("%#x\n", $1); }
|       fixed NL { LOG("Linika z liczbami staloprzecinkowymi\n"); printf("%f\n", $1); }
|       float_e NL { LOG("Linika z liczbami zmiennoprzecinkowymi\n"); printf("%E\n", $1); };

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