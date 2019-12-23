/* a simple calculator program */

/* C Declarations */

%{   
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "Compiler.tab.h"
%}

%option noyywrap

/* Name Definitions */

SPACE " "
DIGIT [0-9]
CHAR [a-zA-Z]
ALPHANUMERIC [a-zA-Z0-9]
RELATIONOP ">"|"<"|"=="|"!="

NUM	{DIGIT}*[.]?{DIGIT}+
VAR {CHAR}{ALPHANUMERIC}*


/* Regular Expressions and Actions */

%%

"def" 	{ return DEF; }
"for" 	{ return FOR; }
"show"	{ return SHOW; }
"if"	{ return IF; }
"else"  { return ELSE; }
"elif"	{ return ELIF; }
"import" { return IMPORT; }

{VAR}".h" { return HEADER; }

{NUM}	{  
			sscanf(yytext, "%lf", &yylval.val); 
			return NUMBER; 
		} 

{VAR}	{
			strcpy(yylval.text, yytext);
			return ID;
		}

"="		{ return ASSIGNOP; }
"+"		{ return PLUS; }
"-"		{ return MINUS; }
"/"		{ return SLASH; }
"*"		{ return ASTERISK; }
"^"		{ return EXPONEN; }
"("		{ return LPAREN; }
")"		{ return RPAREN; }
"\n"	{ return NEWLINE; }
"{"		{ return LBRAC; }
"}"		{ return RBRAC; }
","		{ return COMMA; }
">"		{ return GT; }
"<"		{ return LT; }
"=="	{ return EQ; }
"!="	{ return NEQ; }
">="	{ return GTEQ; }
"<="	{ return LTEQ; }
";"		{ return SEMICOL; }
"//"{VAR}{SPACE}*{VAR}*	{ return COMMENT; }

%%