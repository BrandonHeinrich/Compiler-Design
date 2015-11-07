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

Prog    : BEGIN_TOK StmtSeq END_TOK                                             ;      					
StmtSeq : Stmt StmtSeq                                                          ;
StmtSeq :                                                                       ;
Stmt    : Ident ASSIGN_TOK Expr SEMI_TOK                                        ;
Expr    : Term MExpr                                                            ;
MExpr   : AddOp Term MExpr                                                      ;
MExpr   :                                                                       ;
Term    : Factor MTerm                                                          ;
MTerm   : MultOp Factor MTerm {
    
};
MTerm   :                                                                       ;
Factor  : LPAREN_TOK Expr RPAREN_TOK {
    $$ = $2;
    printf("%s",$2);
};
Factor  : MINUS_TOK Factor {
    $$ = malloc(strlen($1)+strlen($2)+1);
    strcpy($$,$1);
    strcat($$,$2);
    free($1);
    free($2);
};
Factor  : IntLit {
    $$ = $1;
};
Factor  : Ident {
    $$ = $1;
};
AddOp   : MINUS_TOK {
    $$ = $1;
};
AddOp   : PLUS_TOK {
    $$ = $1;
};
MultOp  : TIMES_TOK {
    $$ = $1;
};
MultOp  : DIV_TOK {
    $$ = $1;
};
Ident   : IDENT_TOK {
    $$ = $1;
};
IntLit  : INTLIT_TOK {
    $$ = $1;
};

%%

void yyerror(char *s) {
  printf("err: \"%s\" yytext: \"%s\"\n",s,yytext);
}
