%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define YY_DECL int yylex()

#include "y.tab.h"

%}

%%


[ \t]   ; // ignore all whitespace
[0-9][0-9]*             {yylval.INT = atoi(yytext) ; return T_INT;}
"+"                     {return T_PLUS;}
"-"                     {return T_MINUS;}
"*"                     {return T_MULTIPLY;}
"/"                     {return T_DIVIDE;}
"Print"					{return PRINT;}
"%"                     {return T_MOD;}
"Add"					{return ADD;}
"Assign"				{return ASSIGN;}
"Subtract"				{return SUB;}
"Multiply"				{return MUL;}
"Divide"				{return DIV;}
"by"					{return BY;}
"from"					{return FROM;}
"to"					{return TO;}
"with"					{return WITH;}
\n                      {return T_NEWLINE;}
[a-zA-Z][a-zA-Z0-9]*    {strcpy(yylval.str , yytext) ;return T_ID;}
.						{yyerror("Invalid Syntex!") ;}
%%
