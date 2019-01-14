all:
	${MAKE} grammar
	${MAKE} lex
	g++ lex.yy.c -DYY_SKIP_YYWRAP

grammar:
	bison grammar.y

lex:
	flex lex.l

test:
	${MAKE} all
	./a.out

testdane:
	${MAKE} all
	./a.out < program.txt