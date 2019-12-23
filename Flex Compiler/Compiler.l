%{
	int var = 0, mvar = 0, func = 0, loop = 0, if_else = 0;
	int start_brace;
%}

SPACE " "
DIGIT [0-9]
CHAR [a-zA-Z]
ALPHANUMERIC [a-zA-Z0-9]
DATATYPE "int"|"float"|"double"|"char"|"long long"|"long"
OPERATOR "+"|"-"|"*"|"/"|"^"|"&"|"|"|"!"|"~"|"="
OPERATOR2 "+"|"-"|"*"|"/"|"^"|"&"|"|"|"!"|"~"
COPERATOR ">"|"<"|"=="|"!="

VARIABLE {SPACE}*{CHAR}{ALPHANUMERIC}*{SPACE}*
VARIABLE_DEC {SPACE}*{DATATYPE}{SPACE}*{CHAR}{ALPHANUMERIC}*{SPACE}*
VARIABLE_DEC_MULTI {SPACE}*{DATATYPE}({SPACE}*{CHAR}{ALPHANUMERIC}*{SPACE}*",")+{SPACE}*{CHAR}{ALPHANUMERIC}*{SPACE}*
PARAMETER {SPACE}*|{VARIABLE_DEC}|({VARIABLE_DEC}",")+{VARIABLE_DEC}
HEADER "#include"{SPACE}*"<"{CHAR}{ALPHANUMERIC}*".h"{SPACE}*">"
COMMENT "//"({SPACE}*{ALPHANUMERIC}*{DATATYPE}*{OPERATOR}*";"*)*
FUNCTION {DATATYPE}{SPACE}*("*")?{SPACE}+{CHAR}{ALPHANUMERIC}*{SPACE}*"("{PARAMETER}")"{SPACE}*"{"
OPERATION {VARIABLE}{OPERATOR}{VARIABLE}({OPERATOR2}{VARIABLE})*

%%

{HEADER} {printf("Header File: %s\n", yytext);}

{COMMENT} {printf("Comment: %s\n", yytext);}

{VARIABLE_DEC}";" {
	var++;
	printf("Variable Declaration: %s\n",yytext);
}

{VARIABLE_DEC_MULTI}";" {
	mvar++;
	printf("Multiple Variable Declaration:\n    %s\n",yytext);
}

{FUNCTION} {
	func++;
	start_brace++;
	printf("Function:\n    %s\n", yytext);
}

{OPERATION}";" {
	printf("Arithmatic/Bitwise Operation: %s\n", yytext);
}

"if"{SPACE}*"("{VARIABLE}{COPERATOR}{VARIABLE}")"{SPACE}*"{" {
	start_brace++, if_else++;
	printf("IF condition:\n    %s\n", yytext);
}
"else if"{SPACE}*"("{VARIABLE}{COPERATOR}{VARIABLE}")"{SPACE}*"{" {
	start_brace++;
	printf("ELSE IF condition:\n    %s\n", yytext);
}
"else"{SPACE}*"{" {
	start_brace++;
	printf("Else condition:\n    %s\n", yytext);
}

"while"{SPACE}*"("{VARIABLE}{COPERATOR}{VARIABLE}")"{SPACE}*"{" {
	start_brace++, loop++;
	printf("While Loop Starts:\n    %s\n", yytext);
}

. {
	if(start_brace > 0) {
		if(yytext[0] == '}') start_brace--, printf("    }");
		else printf("%s", yytext);	
	}
	else {
		printf("Unexpected %s;\n", yytext); 
	}
}


%%

int yywrap(){}

int main()
{
	freopen("input.txt", "r", stdin);
	freopen("output.txt", "w", stdout);

	yylex();

	printf("\n\n");
	printf("variables = %d\n", var);
	printf("multiple variables = %d\n", mvar);
	printf("functions = %d\n", func);
	printf("loop = %d\n", loop);
	printf("IF-Else = %d\n", if_else);	

	return 0;
}

