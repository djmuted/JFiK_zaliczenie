all:
	${MAKE} grammar
	${MAKE} lex
	gcc lex.yy.c

grammar:
	/usr/local/opt/bison/bin/bison grammar.y

lex:
	/usr/local/opt/flex/bin/flex lex.l

test:
	${MAKE} all
	./a.out

testdane:
	${MAKE} all
	./a.out < dane.txt