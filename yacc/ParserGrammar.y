%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char*

extern int yylex(); /* The next token function. */
extern char *yytext;/* The matched token text.  */
extern int yyleng;  /* The token text length.   */

void yyerror(char *s);

/* RDGrammar.h
Contains the grammar parsing routines for the grammar
     
                                              Select Set
<Prog>    :== BEGIN <StmtSeq> END         					
<StmtSeq> :== <Stmt> <StmtSeq>	              Ident
<StmtSeq> :== 				      End
<Stmt>	  :== <Ident> := <Expr> ;
<Expr>	  :== <Term> <MExpr>
<MExpr>	  :== <AddOp> <Term> <MExpr>          - +
<MExpr>	  :==                                 ; )
<Term>	  :== <Factor> <MTerm>
<MTerm>	  :== <MultOp> <Factor> <MTerm>       * /
<MTerm>	  :==                                 - + ; )
<Factor>  :== ( <Expr> )
<Factor>  :== - <Factor>
<Factor>  :== <IntLit>
<Factor>  :== <RealLit>
<Factor>  :== <Ident>
<AddOp>	  :== -
<AddOp>	  :== +
<MultOp>  :== *
<MultOp>  :== /
*/

%}

%token EOF_TOK     0
%token BEGIN_TOK   1
%token END_TOK     2
%token ASSIGN_TOK  3
%token SEMI_TOK    4
%token LPAREN_TOK  5
%token RPAREN_TOK  6
%token MINUS_TOK   7
%token PLUS_TOK    8
%token TIMES_TOK   9
%token DIV_TOK     10
%token INTLIT_TOK  11
%token IDENT_TOK   13

%%

Prog    : BEGIN_TOK StmtSeq END_TOK {
    printf("BEGIN\n");
    printf("%s", $2);
    printf("END\n");
};      					
StmtSeq : Stmt StmtSeq {
    $$ = malloc(strlen($1)+strlen($2)+1);
    strcpy($$, $1);
    strcat($$, $2);
    free($1);
    free($2);
};
StmtSeq : {
    $$ = malloc(1);
    strcpy($$, "");
};
Stmt    : Ident ASSIGN_TOK Expr SEMI_TOK {
    $$ = malloc(strlen($1)+strlen($3)+9);
    strcpy($$, "  ");
    strcat($$, $1);
    strcat($$, " := ");
    strcat($$, $3);
    strcat($$, ";\n");
    free($1);
    free($2);
    PostMessage(GetCurrentColumn(), "Found Statement");
};
Expr    : Term MExpr {
    $$ = malloc(strlen($1)+strlen($2)+2);
    strcpy($$, $1);
    if(strlen($2) > 0) {
        strcat($$, " ");
        strcat($$, $2);
    }
    free($1);
    free($2);
};
MExpr   : AddOp Term MExpr {
    $$ = malloc(strlen($1)+strlen($2)+strlen($3)+3);
    strcpy($$, $2);
    strcat($$, " ");
    strcat($$, $1);
    if(strlen($3) > 0) {
        strcat($$, " ");
        strcat($$, $3);
    }
    free($1);
    free($2);
    free($3);
};
MExpr   : {
    $$ = malloc(1);
    strcpy($$, "");
};
Term    : Factor MTerm {
    $$ = malloc(strlen($1)+strlen($2)+2);
    strcpy($$, $1);
    if(strlen($2) > 0) {
        strcat($$, " ");
        strcat($$, $2);
    }
    free($1);
    free($2);
};
MTerm   : MultOp Factor MTerm {
    $$ = malloc(strlen($1)+strlen($2)+strlen($3)+3);
    strcpy($$, $2);
    strcat($$, " ");
    strcat($$, $1);
    if(strlen($3) > 0) {
        strcat($$, " ");
        strcat($$, $3);
    }
    free($1);
    free($2);
    free($3);
};
MTerm   : {
    $$ = malloc(1);
    strcpy($$, "");
};
Factor  : LPAREN_TOK Expr RPAREN_TOK {
    PostMessage(GetCurrentColumn(), "Found Parenthesized Expression");
    $$ = $2;
};
Factor  : MINUS_TOK Factor {
    $$ = malloc(strlen($2)+5);
    strcpy($$, "0 ");
    strcat($$, $2);
    strcat($$, " -");
    free($2);
    PostMessage(GetCurrentColumn()-1, "Found Negated Factor");
};
Factor  : IntLit {
    $$ = $1;
};
Factor  : Ident {
    $$ = $1;
};
AddOp   : MINUS_TOK {
    $$ = malloc(strlen(yytext)+1);
    strcpy($$, yytext);
    PostMessage(GetCurrentColumn()-1, "Found Operator");
};
AddOp   : PLUS_TOK {
    $$ = malloc(strlen(yytext)+1);
    strcpy($$, yytext);
    PostMessage(GetCurrentColumn()-1, "Found Operator");
};
MultOp  : TIMES_TOK {
    $$ = malloc(strlen(yytext)+1);
    strcpy($$, yytext);
    PostMessage(GetCurrentColumn()-1, "Found Operator");
};
MultOp  : DIV_TOK {
    $$ = malloc(strlen(yytext)+1);
    strcpy($$, yytext);
    PostMessage(GetCurrentColumn()-1, "Found Operator");
};
Ident   : IDENT_TOK {
    $$ = malloc(strlen(yytext)+1);
    strcpy($$, yytext);
    PostMessage(GetCurrentColumn()-1, "Found Identifier");
};
IntLit  : INTLIT_TOK {
    $$ = malloc(strlen(yytext)+1);
    strcpy($$, yytext);
    PostMessage(GetCurrentColumn()-1, "Found Integer Literal");
};

%%

void yyerror(char *s) {
  printf("err: \"%s\" yytext: \"%s\"\n",s,yytext);
}
