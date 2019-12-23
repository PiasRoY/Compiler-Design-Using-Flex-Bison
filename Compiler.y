%{
	#include <malloc.h>
	#include <stdlib.h>
	#include <stdio.h>
	#include <math.h>
	#include <string.h>
	#include "functions.h"

	/* given memory for compilation */
	double varList[1000];
	int cnt = 0, exeCnt;
%}

%union {
	double val;
	char text[1003];
}

%token <val> NUMBER
%token <text> ID

%type <val> exp

%token NEWLINE PLUS MINUS SLASH ASTERISK LPAREN RPAREN EXPONEN LBRAC RBRAC DEF COMMA GT LT EQ NEQ GTEQ LTEQ FOR SEMICOL SHOW IF ELSE ELIF IMPORT HEADER COMMENT
%token ASSIGNOP

%left PLUS MINUS
%left ASTERISK SLASH EXPONEN
%left ID
%start prog

%%

prog: /* empty string */
	| prog line
	;

line: NEWLINE
	| exp NEWLINE
	| agn NEWLINE
	| func NEWLINE
	| loop NEWLINE
	| print NEWLINE
	| if NEWLINE
	| import NEWLINE
	| COMMENT NEWLINE
	;

/* assignment begins */

agn: ID ASSIGNOP exp {
						int tmp = query($1);
						if(tmp == -1) tmp = insert($1);

						varList[tmp] = $3;
					};

/* assignment ends */

/* expressions begins */

exp: NUMBER			{ $$ = $1; }
	| ID 			{	
						int tmp = query($1);
						if(tmp == -1) {
							printf("Compilation Error: %s is not declared\n", $1);
							exit(-1);
						}
						else {
							$$ = varList[tmp];
						}
					}
    | exp PLUS exp		{ $$ = $1 + $3; }
    | exp MINUS exp 	{ $$ = $1 - $3; }
    | exp ASTERISK exp	{ $$ = $1 * $3; }
    | exp SLASH exp		{
    						if($3 == 0) {
    							printf("invalid operation: can't divide by zero\n");
    							exit(-1);
    						} 
    						$$ = $1 / $3; 
    					}
    | exp EXPONEN exp	{ $$ = powl($1, $3); }
    | LPAREN exp RPAREN	{ $$ = $2; }
    | exp GT exp 		{ $$ = ($1>$3); }
    | exp LT exp 		{ $$ = ($1<$3); }
    | exp EQ exp 		{ $$ = ($1==$3); }
    | exp NEQ exp 		{ $$ = ($1!=$3); }
    | exp GTEQ exp 		{ $$ = ($1>=$3); }
    | exp LTEQ exp 		{ $$ = ($1<=$3); }
	;

/* expressions ends */

/* function starts */

func: DEF ID LPAREN params RPAREN LBRAC NEWLINE inFunc RBRAC
	{
		printf("FUNC Declared!\n");		
	};

inFunc: /* empty string */
		| NEWLINE inFunc
	 	| exp NEWLINE inFunc
	 	| agn NEWLINE inFunc

params:   /* empty strings */
		| param
		| param COMMA params
		;

param:	 ID {	
				int tmp = query($1);
				if(tmp != -1) {
					printf("Compilation Error: redeclaration of %s\n", $1);
					exit(-1);
				}
				else {
					insert($1);
				}
			}
		;

/* function ends */

/* for-loop begins */

loop: FOR LPAREN ID ASSIGNOP exp SEMICOL ID LTEQ exp SEMICOL NUMBER RPAREN LBRAC RBRAC 
{
	int i = $5;
	int range = $9;
	int incr = $11;

	for(; i <= range; i += incr) {
		printf("LOOP IS RUNNING for %d time\n", i);
	}
}

/* for-loop ends */

/* printer begins */

print: SHOW LPAREN vals RPAREN;

vals: 	  /* empty string */
		| NUMBER { printf("%.10f\n", $1); }
		| NUMBER COMMA vals { printf("%.10f\n", $1); }
		| ID{
				int tmp = query($1);
				if(tmp == -1) {
					printf("Compilation Error: %s isnot declared!\n", $1);
					exit(-1);
				} 
				else printf("%.10f\n", varList[tmp]); 
			} 
		| ID COMMA vals {
							int tmp = query($1);
							if(tmp == -1) {
								printf("Compilation Error: %s isnot declared!\n", $1);
								exit(-1);
							} 
							else printf("%.10f\n", varList[tmp]); 
						} 
		;

/* printer ends */

/* Conditional OP begins */

if: IF LPAREN exp RPAREN LBRAC inCOD RBRAC NEWLINE elseif else
	{
		cnt++;
		if($3) exeCnt = cnt;

		if(exeCnt == cnt) printf("IF will be executed!\n");
		else if(exeCnt > 1) printf("%d-th ELIF will be executed!\n", cnt-exeCnt);
		else printf("ELSE will be executed!\n");

		cnt = 0;
	};

elseif: /* empty string */
		| ELIF LPAREN exp RPAREN LBRAC inCOD RBRAC NEWLINE elseif else 
		{
			cnt++;
			if($3) exeCnt = cnt;
		};

else: /* empty string */
	  | ELSE LBRAC inCOD RBRAC 
	  	{ 
	  		cnt++; 
	  		exeCnt = cnt;
	  	};

inCOD:   /* empty string */
		| COMMENT NEWLINE inCOD
		| NEWLINE inCOD
	 	| exp NEWLINE inCOD
		| agn NEWLINE inCOD
		;

/* Conditional OP ends */

/* header begins */

import: IMPORT HEADER { printf("Header File Found!"); }

/* header ends */


%%

int yyerror(char *s) /* called by yyparse on error */
{     
	printf("%s\n",s);
	return(0);
}

int main(void)
{
	//freopen("input.txt", "r", stdin);
	//freopen("output.txt", "w", stdout);

	initialize(); //from functions.h
	yyparse();

	exit(0);
}