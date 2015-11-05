%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();	    /* The next token function. */
extern char *yytext;    /* The matched token text.  */
extern int yyleng;      /* The token text length.   */

void yyerror(char *s);

#define YYSTYPE long    /* 64 bit so can hold pointer and int */

%}


%token BEGIN 	1 	END 		2
%token Ident 	3 	IntLit 	4
%token EQUAL 	5
%token PLUS 	6 	MINUS 	7 	TIMES     8 	DIVIDES 	9
%token LPAREN 10 	RPAREN 	11  SEMICOLON 12

%%

Prog		:	BEGIN StmtSeq END       { printf("Prog\n"); } ;
StmtSeq :	Stmt StmtSeq            { } ;
StmtSeq	:                         { } ;
Stmt		:	Id EQUAL Expr SEMICOLON	{ printf("assign: %s %d\n",$1,$3); } ;
Expr		:	Term PLUS Expr					{ $$ = $1 + $3; } ;
Expr		:	Term MINUS Expr					{ $$ = $1 - $3; } ;
Expr		:	Term                    { $$ = $1; } ;
Term		:	Factor TIMES Term				{ $$ = $1 * $3; } ;
Term		:	Factor DIVIDES Term			{ $$ = $1 / $3; } ;
Term		:	Factor                  { $$ = $1; } ;
Factor	:	LPAREN Expr RPAREN			{ $$ = $2; } ;
Factor	:	MINUS Factor						{ $$ = - $2; } ;
Factor	:	IntLit                  { printf("lit: %s\n",yytext); $$ = atoi(yytext); } ;
Id			: Ident                   { printf("id: %s\n",yytext); $$ = strdup(yytext); } ;
 
%%

int
main(int argc, char *argv[])
{
	yyparse();
}

void
yyerror(char *s)
{
  printf("err: \"%s\" yytext: \"%s\"\n",s,yytext);
}
