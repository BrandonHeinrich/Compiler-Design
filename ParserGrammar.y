%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();	/* The next token function. */
extern char *yytext;   /* The matched token text.  */
extern int yyleng;      /* The token text length.   */

void yyerror(char *s);

#define YYSTYPE long

%}

%token BEGIN 	1 	END 	2

%%
Prog	:	BEGIN StmtSeq END														;
StmtSeq :	Stmt StmtSeq															;
StmtSeq	:																						;
Stmt	:	Ident Assign Expr ';'			{ printf("\n"); } ;

%%

void
yyerror(char *s)
{
  printf("err: \"%s\" yytext: \"%s\"\n",s,yytext);
}
