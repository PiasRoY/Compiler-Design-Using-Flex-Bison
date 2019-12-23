/* a simple calculator program */

/* C Declarations */

%{   
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "infix.tab.h"
	extern YYSTYPE yylval;
%}

%option noyywrap

/* Name Definitions */

delim	[ \t]
whitesp	{delim}+
digit	[0-9]
number	{digit}*[.]?{digit}+

/* Regular Expressions and Actions */

%%

{number}	{ sscanf(yytext, "%lf", &yylval); return NUMBER;}
"+"		{ return PLUS; }
"-"		{ return MINUS; }
"/"		{ return SLASH; }
"*"		{ return ASTERISK; }
"("		{ return LPAREN; }
")"		{ return RPAREN; }
"\n"		{ return NEWLINE; }
{whitesp}	{ /* No action and no return */}

%%