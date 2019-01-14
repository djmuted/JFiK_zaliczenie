all:
	${MAKE} grammar
	${MAKE} lex
	gcc lex.yy.c

grammar:
	bison grammar.y

lex:
	flex lex.l

test:
	${MAKE} all
	./a.out

testdane:
	${MAKE} all
	./a.out < dane.txt