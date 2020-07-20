Token and Regular Expression
- [ \t]                       ; // ignore all whitespace
- [0-9][0-9]*                 {return T_INT;}
- "+"                         {return T_PLUS;}
- "-"                         {return T_MINUS;}
- "*"                         {return T_MULTIPLY;}
- "/"                         {return T_DIVIDE;}
- "Print"                     {return PRINT;}
- "%"                         {return T_MOD;}
- "Add"                       {return ADD;}
- "Assign"                    {return ASSIGN;}
- "Subtract"                  {return SUB;}
- "Multiply"                  {return MUL;}
- "Divide"                    {return DIV;}
- "by"                        {return BY;}
- "from"                      {return FROM;}
- "to"                        {return TO;}
- "with"                      {return WITH;}
- \n                          {return T_NEWLINE;}
- [a-zA-Z][a-zA-Z0-9]*        {return T_ID;}
- .                           {yyerror("Invalid Syntex!") ;}

Grammer
PROG:  STMTS	

STMTS:					   
     | STMT T_NEWLINE STMTS 
     | T_NEWLINE STMTS
     | STMT 					
;

STMT:  EXPR
     | PRINT EXPR			 
     | ASSIGN T_ID TO EXPR 	 
;

EXPR:  ADD EXPR WITH EXPR 	 
     | SUB EXPR FROM EXPR 	 
     | MUL EXPR BY EXPR 		 
     | DIV EXPR BY EXPR 		 	
     | RPN					 
     | TERM 					 
;

RPN:   TERM RPN				 
     | OP RPN				 
     | OP					 
;
 

TERM:  T_INT					 
     | T_ID 					 
;

OP:    T_PLUS				 
     | T_MINUS				 
     | T_MULTIPLY			 
     | T_DIVIDE				 
     | T_MOD					 
;
