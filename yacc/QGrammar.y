%{
#include "IOMngr.h"
#include "Scanner.h"
#include "Semantics.h"
#include "CodeGen.h"
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

/* List of tokens*/
%token IDENT_TOK
%token COMMA_TOK
%token INT_TOK
%token CHAR_TOK
%token MAIN_TOK
%token LBRACE_TOK
%token RBRACE_TOK
%token SEMI_TOK

%%

prog : decls body {
    PostMessage(GetCurrentColumn(), "Found Program!");
};



decls: decl decls;



decls: ;



decl: type idlist SEMI_TOK {
    PostMessage(GetCurrentColumn(), "Found Declaration!");
}



type: INT_TOK {
    PostMessage(GetCurrentColumn(), "Found Integer Type!");
};



type: CHAR_TOK {
    PostMessage(GetCurrentColumn(), "Found Character Type!");
};



idlist: id COMMA_TOK idlist;



idlist: id {
    PostMessage(GetCurrentColumn(), "Found ID List!");
};



idlist: {
    PostMessage(GetCurrentColumn(), "Found ID List!");
};



id: IDENT_TOK {
    PostMessage(GetCurrentColumn(), "Found Identifier!");
};



body: MAIN_TOK LBRACE_TOK stmtseq RBRACE_TOK {
    PostMessage(GetCurrentColumn(), "Found Body!");
};



stmtseq: {
    PostMessage(GetCurrentColumn(), "Found Statement Sequence!");
};



%%

void
yyerror( char *s)
{
  char msg[MAXLINE];
  sprintf(msg,"ERROR \"%s\" token: \"%s\"",s,yytext);
  PostMessage(GetCurrentColumn(),msg);
}