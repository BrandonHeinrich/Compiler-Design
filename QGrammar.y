%{
#include "IOMngr.h"
#include "Scanner.h"
#include "Semantics.h"
#include <string.h>

void yyerror(char *s);
%}

/* Union structure of data that can be attached to non-terminals */ 
%union {
  char * Text;
  struct IdList * IdList;
  struct TypeDesc * TypeDesc;
	struct InstrSeq * InstrSeq;
}

/* Type declaration for data attched to non-terminals. Allows */
/* $# notation to be correctly type cased for function arguments. */
/* %type <union-field-name> non-terminal */
%type <Text> Id
%type <IdList> IdList
%type <TypeDesc> Type
%type <InstrSeq> Decl
%type <InstrSeq> Decls
%type <InstrSeq> Body

/* List of token name and corresponding numbers */
/* This must agree with QTokens.h */
%token IDENT_TOK 1 INT_TOK 2 CHAR_TOK 3 MAIN_TOK 4
%token LBRACE_TOK 5 RBRACE_TOK 6 SEMICOLON_TOK 7 COLON_TOK 8
%token COMMA_TOK 9

%%

Prog		: Decls Body                              { Finish($1,$2); } ;
Id			: IDENT_TOK                               { $$ = strdup(yytext); };
Decls   : Decl  Decls                             ;
Decls   :                                         ;
Decl		: Type IdList SEMICOLON_TOK								{ $$ = ProcDecl($2,$1); };
IdList	: IdList COMMA_TOK Id											{ $$ = ChainUndId($1,$3); };
IdList	: Id                                      { $$ = ProcUndId($1); };
Type		: INT_TOK                                 { $$ = ProcTypeDesc(IntBaseType); };
Type		: CHAR_TOK                                { $$ = ProcTypeDesc(ChrBaseType); };
Body		: MAIN_TOK LBRACE_TOK StmtSeq RBRACE_TOK	;
StmtSeq	: Stmt SEMICOLON_TOK StmtSeq							;
StmtSeq	:                                         ;
Stmt		:                                         ;

%%

void
yyerror( char *s)
{
  char msg[MAXLINE];
  sprintf(msg,"ERROR \"%s\" token: \"%s\"",s,yytext);
  PostMessage(GetCurrentColumn(),msg);
}