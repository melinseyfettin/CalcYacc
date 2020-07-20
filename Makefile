all: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c -o CalcYacc -lfl -lm

lex.yy.c: CalcYacc.l
	lex CalcYacc.l

y.tab.c: CalcYacc.y
	yacc -d CalcYacc.y
	
clean:
	rm -f lex.yy.c y.tab.c y.tab.h CalcYacc
