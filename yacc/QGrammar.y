%{
#include "IOMngr.h"
#include "Scanner.h"
#include "Semantics.h"
#include "CodeGen.h"
#include "Semantics.h"
#include <string.h>

void yyerror(char *s);

%}

/* Union structure of data that can be attached to non-terminals */ 
%union {
    char *Text;
    struct IdList *IdList;
    struct TypeDesc *TypeDesc;
    struct InstrSeq *InstrSeq;
}

/* Type declaration for data attched to non-terminals. Allows */
/* $# notation to be correctly type cased for function arguments. */
/* %type <union-field-name> non-terminal */

%type <Text> id
%type <IdList> idlist
%type <TypeDesc> type
%type <InstrSeq> decl
%type <InstrSeq> decls
%type <InstrSeq> body

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
    //PostMessage(GetCurrentColumn(), "Found Program!");
    Finish($1, $2);
};



decls: decl decls {
    $$ = $1;
    struct InstrSeq *tail = $$;
    while(tail->Next != NULL) {
        tail = tail->Next;
    }
    tail->Next = $2;
    //PostMessage(GetCurrentColumn(), "Found decls!");
}



decls: {
    $$ = NULL;
    //PostMessage(GetCurrentColumn(), "Found empty decls!");
};



decl: type idlist SEMI_TOK {
    //PostMessage(GetCurrentColumn(), "Found Declaration!");
    $$ = ProcDecl($2,$1);
}
type: INT_TOK {
    //PostMessage(GetCurrentColumn(), "Found Integer Type!");
    $$ = ProcTypeDesc(IntBaseType);
};
type: CHAR_TOK {
    //PostMessage(GetCurrentColumn(), "Found Character Type!");
    $$ = ProcTypeDesc(ChrBaseType);
};
idlist	: idlist COMMA_TOK id {
    $$ = ChainIdentifier($1,$3);
};

idlist	: id {
    $$ = ProduceIdentifier($1);
};



id: IDENT_TOK {
    //PostMessage(GetCurrentColumn(), "Found Identifier!");
    $$ = strdup(yytext);
};



body: MAIN_TOK LBRACE_TOK stmtseq RBRACE_TOK {
    //PostMessage(GetCurrentColumn(), "Found Body!");
};



stmtseq: {
    //PostMessage(GetCurrentColumn(), "Found Statement Sequence!");
};



%%

void yyerror(char *s) {
  char msg[MAXLINE];
  sprintf(msg,"ERROR \"%s\" token: \"%s\"",s,yytext);
  PostMessage(GetCurrentColumn(),msg);
}