%{
    //#define DEBUG
	#ifdef DEBUG
		#define LOG printf
	#else
		#define LOG lognull
	#endif  
	void lognull(const char *format, ...) {}
    #include "grammar.tab.c"
	int curIndex = 1;
%}

%%
[ \t]+[1-9]+[0-9]* { LOG("Lex: DEC\n"); yylval.ival = atoi(yytext); return DECIMAL; }
[ \t]+0x[0-9A-F]+ { LOG("Lex: HEX\n"); yylval.ival = strtol(yytext, NULL, 16); return HEX; }
[ \t]+(([1-9]+[0-9]*)|0)\.[0-9]+ { LOG("Lex: STALOPRZECINKOWA\n"); yylval.fval = atof(yytext); return FIXED; }
[ \t]+[0-9]+(\.[0-9]+)E[-+][0-9]+ { LOG("Lex: ZMIENNOPRZECINKOWA\n"); yylval.fval = atof(yytext); return FLOAT_E; }
[1-9]+[0-9]* { LOG("Lex: INDEKS\n"); yylval.ival = atoi(yytext); if(curIndex++ == atoi(yytext)) return INDEX; else return UNDEFINED; }
[\r]?[\n] { LOG("Lex: NL\n"); return NL; }
. { return UNDEFINED; }
%%
