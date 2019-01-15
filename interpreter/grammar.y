%{
    #include <stdio.h>
    #include <string.h>
    #include <cstdlib>
    #include <vector>
    #include <string>
    #include <iostream>
    void yyerror(char*);
    int yylex();
    int liczbaZmiennych = 0;
    std::vector<std::string> zmienne;
    std::vector<int> wartosci;
    int indeksZmiennej(char* nazwa);
    enum OPTYPE
    {
        OP_SET,
        OP_ADD,
        OP_SUB,
        OP_MUL,
        OP_DIV,
        OP_PRINT,
        OP_IF,
        OP_WHILE
    };
    struct E_STRUCT
    {
        enum OPTYPE optype;
        int isArg1Str;
        int isArg1E;
        int isArg2Str;
        int intArg1;
        int intArg2;
        struct E_STRUCT* eArg1 = nullptr;
        char* strArg1;
        char* strArg2;
        int solution;
        char* solutionStr;
        int hasSolution;
        bool isValue = false;
        void recalculate()
        {
            this->hasSolution = 0;
            if (this->eArg1)
            {
                this->eArg1->recalculate();
            }
        }
    };
    class OPERATION
    {
    public:
        enum OPTYPE optype;
        struct E_STRUCT* e;
        char* dest;
        OPERATION* toRunIfTrue;
        OPERATION* toRunIfTrue2;
        bool runMe;
        std::string cond;
        struct E_STRUCT* e2;
        OPERATION(enum OPTYPE optype, E_STRUCT* e)
        {
            this->e = e;
            this->optype = optype;
            this->runMe = true;
        }
    };
    std::vector<OPERATION*> opVec;
    int opVecSize = 0;
    void addOP(OPERATION* op)
    {
        opVec.push_back(op);
    }
    int indeksZmiennej(char* nazwa)
    {
        // printf("Szukanie zmiennej %s\n", nazwa);
        for (int i = 0; i < liczbaZmiennych; i++)
        {
            if (std::string(nazwa) == zmienne[i])
            {
                return i;
            }
        }
        return -1;
    }
    void setVariable(char* name, int val)
    {
        if (indeksZmiennej(name) >= 0)
        {
            printf("zmienna %s istnieje, przypisano do niej wartosc %d\n", name, val);
            wartosci[indeksZmiennej(name)] = val;
        }
        else
        {
            printf(
                "zmienna %s nie istnieje, utworzono ja i przypisano do niej wartosc %d\n", name, val);
            zmienne.push_back(std::string(name));
            wartosci.push_back(val);
            liczbaZmiennych += 1;
        }
    }

    struct E_STRUCT* createE_IntStr(int arg1, enum OPTYPE optype, char* arg2)
    {
        struct E_STRUCT* e = new E_STRUCT();
        e->isArg1Str = 0;
        e->isArg2Str = 1;
        e->intArg1 = arg1;
        e->strArg2 = arg2;
        e->optype = optype;
        e->hasSolution = 0;
        e->solutionStr = 0;
        return e;
    }
    struct E_STRUCT* createE_StrInt(char* arg1, enum OPTYPE optype, int arg2)
    {
        struct E_STRUCT* e = new E_STRUCT();
        e->isArg1Str = 1;
        e->isArg2Str = 0;
        e->strArg1 = arg1;
        e->intArg2 = arg2;
        e->optype = optype;
        e->hasSolution = 0;
        e->solutionStr = 0;
        return e;
    }
    struct E_STRUCT* createE_StrStr(char* arg1, enum OPTYPE optype, char* arg2)
    {
        struct E_STRUCT* e = new E_STRUCT();
        e->isArg1Str = 1;
        e->isArg2Str = 1;
        e->strArg1 = arg1;
        e->strArg2 = arg2;
        e->optype = optype;
        e->hasSolution = 0;
        e->solutionStr = 0;
        return e;
    }
    struct E_STRUCT* createE_EStr(struct E_STRUCT* arg1, enum OPTYPE optype, char* arg2)
    {
        struct E_STRUCT* e = new E_STRUCT();
        e->isArg1Str = 0;
        e->isArg1E = 1;
        e->isArg2Str = 1;
        e->eArg1 = arg1;
        e->strArg2 = arg2;
        e->optype = optype;
        e->hasSolution = 0;
        e->solutionStr = 0;
        return e;
    }
    struct E_STRUCT* createE_EInt(struct E_STRUCT* arg1, enum OPTYPE optype, int arg2)
    {
        struct E_STRUCT* e = new E_STRUCT();
        e->isArg1Str = 0;
        e->isArg1E = 1;
        e->isArg2Str = 0;
        e->eArg1 = arg1;
        e->intArg2 = arg2;
        e->optype = optype;
        e->hasSolution = 0;
        e->solutionStr = 0;
        return e;
    }
    struct E_STRUCT* createE_SolutionInt(int arg1)
    {
        struct E_STRUCT* e = new E_STRUCT();
        e->isArg1Str = 0;
        e->isArg1E = 0;
        e->isArg2Str = 0;
        e->solution = arg1;
        e->intArg1 = arg1;
        e->isValue = true;
        e->hasSolution = 1;
        e->solutionStr = 0;
        return e;
    }
    struct E_STRUCT* createE_SolutionStr(char* arg1)
    {
        struct E_STRUCT* e = new E_STRUCT();
        e->isArg1Str = 0;
        e->isArg1E = 0;
        e->isArg2Str = 0;
        e->solutionStr = arg1;
        e->hasSolution = 0;
        return e;
    }
    int doIntIntMath(int arg1, int arg2, enum OPTYPE optype)
    {
        switch (optype)
        {
            case OP_ADD:
            {
                return arg1 + arg2;
                break;
            }
            case OP_SUB:
            {
                return arg1 - arg2;
                break;
            }
            case OP_DIV:
            {
                return arg1 / arg2;
                break;
            }
            case OP_MUL:
            {
                return arg1 * arg2;
                break;
            }
        }
        return 0;
    }
    int resolveE(struct E_STRUCT* arg)
    {
        if (arg->hasSolution)
        {
            return arg->solution;
        }
        if (arg->isValue)
        {
            arg->solution = arg->intArg1;
            arg->hasSolution = 1;
            return arg->intArg1;
        }
        if (arg->solutionStr != 0)
        {
            int varValue = wartosci[indeksZmiennej(arg->solutionStr)];
            arg->solution = varValue;
            arg->hasSolution = 1;
            return varValue;
        }
        int arg1Val = 0;
        int arg2Val = 0;
        if (arg->isArg1E)
        {
            arg1Val = resolveE(arg->eArg1);
        }
        else if (arg->isArg1Str)
        {
            arg1Val = wartosci[indeksZmiennej(arg->strArg1)];
        }
        else
        {
            arg1Val = arg->intArg1;
        }
        if (arg->isArg2Str)
        {
            arg2Val = wartosci[indeksZmiennej(arg->strArg2)];
        }
        else
        {
            arg2Val = arg->intArg2;
        }
        arg->solution = doIntIntMath(arg1Val, arg2Val, arg->optype);
        arg->hasSolution = 1;
        return arg->solution;
    }
    void processInstruction(OPERATION* op)
    {
        op->e->recalculate();
        switch (op->optype)
        {
            case OP_SET:
            {
                setVariable(op->dest, resolveE(op->e));
                break;
            }
            case OP_PRINT:
            {
                printf("PRINT: %d\n", resolveE(op->e));
                break;
            }
            case OP_IF:
            {
                int e1 = resolveE(op->e);
                int e2 = resolveE(op->e2);
                bool run = false;
                if (op->cond == ">")
                {
                    if (e1 > e2)
                        run = true;
                }
                else if (op->cond == "<")
                {
                    if (e1 < e2)
                        run = true;
                }
                else if (op->cond == "==")
                {
                    if (e1 == e2)
                        run = true;
                }
                else if (op->cond == "!=")
                {
                    if (e1 != e2)
                        run = true;
                }
                else if (op->cond == ">=")
                {
                    if (e1 >= e2)
                        run = true;
                }
                else if (op->cond == "<=")
                {
                    if (e1 <= e2)
                        run = true;
                }
                std::cout << "IF: "
                        << (run ? "true, wykonujemy instrukcje" : "false, nie wykonujemy instrukcji")
                        << "\n";
                if (run)
                {
                    processInstruction(op->toRunIfTrue);
                }
                break;
            }
            case OP_WHILE:
            {
                bool run = true;
                while (run)
                {
                    op->e->recalculate();
                    op->e2->recalculate();
                    int e1 = resolveE(op->e);
                    int e2 = resolveE(op->e2);
                    run = false;
                    if (op->cond == ">")
                    {
                        if (e1 > e2)
                            run = true;
                    }
                    else if (op->cond == "<")
                    {
                        if (e1 < e2)
                            run = true;
                    }
                    else if (op->cond == "==")
                    {
                        if (e1 == e2)
                            run = true;
                    }
                    else if (op->cond == "!=")
                    {
                        if (e1 != e2)
                            run = true;
                    }
                    else if (op->cond == ">=")
                    {
                        if (e1 >= e2)
                            run = true;
                    }
                    else if (op->cond == "<=")
                    {
                        if (e1 <= e2)
                            run = true;
                    }
                    std::cout << "WHILE: " << (run ? "true, wykonujemy instrukcje"
                                                : "false, nie wykonujemy instrukcji")
                            << "\n";
                    if (run)
                    {
                        processInstruction(op->toRunIfTrue);
                        processInstruction(op->toRunIfTrue2);
                    }
                }
                break;
            }
        }
    }
    void processOperations()
    {
        for (int i = 0; i < opVec.size(); i++)
        {
            if (opVec[i]->runMe)
            {
                printf("Instrukcja %d\n", i);
                OPERATION* op = opVec[i];
                processInstruction(op);
            }
        }
    }
%}

%union {
    int iValue;
    char * vName;
    struct E_STRUCT * eValue;
    OPERATION * oValue;
};

%start S
%token <iValue> LICZBA 
%type <eValue> E
%type <vName> ZMIENNA
%type <oValue> ZADANIE
%type <vName> COND
%token UNK PRINT ZMIENNA IF COND WHILE INCREMENT DECREMENT

%%
S : ZADANIE ';' S
  | /*nic*/
  ;
ZADANIE : PRINT E { printf("Operacja print\n"); OPERATION * op = new OPERATION(OP_PRINT, $2); addOP(op); $$ = op; }
		| ZMIENNA '=' E {
            printf("Operacja ustawienia wartosci zmiennej\n");
            OPERATION * op = new OPERATION(OP_SET, $3);
            op->dest = $1;
			addOP(op);
            $$ = op;
		}
        | ZMIENNA INCREMENT {
            printf("Operacja inkrementacji zmiennej\n");
            OPERATION * op = new OPERATION(OP_SET, createE_StrInt($1, OP_ADD, 1));
            op->dest = $1;
			addOP(op);
            $$ = op;
        }
        | ZMIENNA DECREMENT {
            printf("Operacja dekrementacji zmiennej\n");
            OPERATION * op = new OPERATION(OP_SET, createE_StrInt($1, OP_SUB, 1));
            op->dest = $1;
			addOP(op);
            $$ = op;
        }
        | IF E COND E ZADANIE {
            printf("Operacja warunkowa\n");
            OPERATION * op = new OPERATION(OP_IF, $2);
            op->e2 = $4;
            op->cond = std::string($3);
            op->toRunIfTrue = $5;
            $5->runMe = false;
			addOP(op);
            $$ = op;
        }
        | WHILE E COND E ZADANIE ZADANIE {
            printf("Operacja pętli\n");
            OPERATION * op = new OPERATION(OP_WHILE, $2);
            op->e2 = $4;
            op->cond = std::string($3);
            op->toRunIfTrue = $5;
            op->toRunIfTrue2 = $6;
            $5->runMe = false;
            $6->runMe = false;
			addOP(op);
            $$ = op;
        }
		;

E : LICZBA	{ $$ = createE_SolutionInt($1); }
  | ZMIENNA { $$ = createE_SolutionStr($1); }
  | E '+' LICZBA { $$ = createE_EInt($1, OP_ADD, $3); }
  | E '*' LICZBA { $$ = createE_EInt($1, OP_MUL, $3); }
  | E '-' LICZBA { $$ = createE_EInt($1, OP_SUB, $3); }
  | E '/' LICZBA { $$ = createE_EInt($1, OP_DIV, $3); }  
  | E '+' ZMIENNA { $$ = createE_EStr($1, OP_ADD, $3); }
  | E '*' ZMIENNA { $$ = createE_EStr($1, OP_MUL, $3); }
  | E '-' ZMIENNA { $$ = createE_EStr($1, OP_SUB, $3); }
  | E '/' ZMIENNA { $$ = createE_EStr($1, OP_DIV, $3); }
  ;

%%
void yyerror(char* str)
{
	printf("%s",str);
}
int yywrap()
{
	return 1;
}
int main()
{
    printf("ETAP ANALIZY:\n");
	int wynik = yyparse();
    if(wynik == 0) { 
        printf("ETAP WYKONYWANIA:\n");
        processOperations();
    }
    return 0;
}