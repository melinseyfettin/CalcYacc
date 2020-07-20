%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s); 
void PutInStack(int val);
int getvalue(char * name);
void setvalue(char * name,int val);
int stack[10003],idx = 10001;
%}

%union {
	int INT; 
	char str[100]; 
}



%token PRINT T_NEWLINE ASSIGN ADD TO WITH SUB MUL DIV BY FROM
%token<INT> T_INT 
%token<str> T_ID
%type<INT> TERM RPN EXPR


%left T_MINUS 
%left T_PLUS
%left T_MULTIPLY 
%left T_DIVIDE    
%left T_MOD    


%start PROG

%%
PROG: STMTS	
;

STMTS:						{ printf("Program End"); exit(0) ;}
	| STMT T_NEWLINE STMTS 
	| T_NEWLINE STMTS
	| STMT 					{ printf("Program End"); exit(0) ;}
;
 
STMT: EXPR
	| PRINT EXPR			{printf("%d\n",$2);}
	| ASSIGN T_ID TO EXPR 	{setvalue($2,$4);}
;

EXPR: ADD EXPR WITH EXPR 	{$$ = $2 + $4;}
	| SUB EXPR FROM EXPR 	{$$ = $2 - $4;}
	| MUL EXPR BY EXPR 		{$$ = $2 * $4;}
	| DIV EXPR BY EXPR 		{ if($4!=0) $$ = $2 / $4;else yyerror("Wrong Expression!");}	
	| RPN					{$$ = $1;}
	| TERM 					{$$ = $1;}
;

RPN:  VALUE RPN				{$$=$2;}
	| OP RPN				{$$=$2;}
	| OP					{if(idx==10000) $$=stack[idx++];else yyerror("Wrong Expression!");}
;

VALUE: TERM					{PutInStack($1);}
;

TERM: T_INT					{$$=$1;}
	| T_ID 					{$$=getvalue($1);}
;

OP:   T_PLUS				{ if(10001-idx>=2){stack[idx+1] =stack[idx+1] + stack[idx];idx++; } else{yyerror("Wrong Expression!");}  }
    | T_MINUS				{ if(10001-idx>=2){stack[idx+1] =stack[idx+1] - stack[idx];idx++; } else{yyerror("Wrong Expression!");}}
    | T_MULTIPLY			{ if(10001-idx>=2){stack[idx+1] =stack[idx+1] * stack[idx];idx++; } else{yyerror("Wrong Expression!");}}
    | T_DIVIDE				{ if(10001-idx>=2 && stack[idx] !=0 ){stack[idx+1] =stack[idx+1] / stack[idx];idx++; } else{yyerror("Wrong Expression!");}}
    | T_MOD					{ if(10001-idx>=2 && stack[idx] !=0 ){stack[idx+1] =stack[idx+1] % stack[idx];idx++; } else{yyerror("Wrong Expression!");}}
;

%%
int countVariable=0;
char* NameOfVariable[10002];
int value[10002];

int main() {
	yyin = stdin;
	do { 
		yyparse();
	} while(!feof(yyin));
	return 0;
}

void yyerror(const char* s) { 
	fprintf(stderr, "%s\n", s); 
	exit(1);
}

void PutInStack(int val){ 
	stack[--idx] = val;
}

int getvalue(char * name){
	int i =0;
	for(i=0;i<countVariable;i++){
		if(strcmp(name,NameOfVariable[i] )==0 ){
			return value[i];
		}
	}
	yyerror(strcat(name, ": Does not exist!!"));	
}

void setvalue(char * name,int val){
	int i =0;  
	for(i=0;i<countVariable;i++){
		if(strcmp(name,NameOfVariable[i] )==0 ){
			value[i] = val; 
			return ;
		}
	}

	value[countVariable] = val;
	NameOfVariable[countVariable] = strdup(name);
	countVariable++;		
}
