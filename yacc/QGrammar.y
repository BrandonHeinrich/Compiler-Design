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
    int Operation;
}

/* Type declaration for data attched to non-terminals. Allows */
/* $# notation to be correctly type cased for function arguments. */
/* %type <union-field-name> non-terminal */

%type <Text> id
%type <Text> string
%type <IdList> idlist
%type <TypeDesc> type
%type <InstrSeq> decl
%type <InstrSeq> decls
%type <InstrSeq> body
%type <InstrSeq> block
%type <InstrSeq> statement
%type <InstrSeq> stmtseq
%type <InstrSeq> rvalue
%type <InstrSeq> factor
%type <InstrSeq> value
%type <Operation> add_op
%type <Operation> mul_op
%type <Operation> bool_op

/* List of tokens*/
%token IDENT_TOK
%token COMMA_TOK
%token INT_TOK
%token CHAR_TOK
%token MAIN_TOK
%token LBRACE_TOK
%token RBRACE_TOK
%token SEMI_TOK
%token ASSIGN_TOK
%token PLUS_TOK
%token MINUS_TOK
%token TIMES_TOK
%token DIV_TOK
%token INT_LIT_TOK
%token GET_TOK
%token PUT_TOK
%token LPAREN_TOK
%token RPAREN_TOK
%token STR_LIT_TOK

%token WHILE_TOK
%token GREATER_TOK
%token LESS_TOK
%token GREATEREQ_TOK
%token LESSEQ_TOK
%token EQUAL_TOK
%token NOTEQUAL_TOK

%%

prog : decls body {
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
body: MAIN_TOK block {
    $$ = $2;
};
stmtseq: statement stmtseq {
    AppendSeq($1, $2);
    $$ = $1;
};
stmtseq: {
    //PostMessage(GetCurrentColumn(), "Found Statement Sequence!");
};
statement: id ASSIGN_TOK rvalue SEMI_TOK {
    $$ = $3;
    char *label = strdup("_");
    strcat(label, $1);
    AppendSeq($$, GenInstr(NULL, "sw", "$t1", label, NULL));
};
statement: PUT_TOK LPAREN_TOK string RPAREN_TOK SEMI_TOK {
    $$ = GenInstr(NULL, "li", "$v0", "4", NULL);
    AppendSeq($$, GenInstr(NULL, "la", "$a0", $3, NULL));
    AppendSeq($$, GenInstr(NULL, "syscall", NULL, NULL, NULL));
};
statement: PUT_TOK LPAREN_TOK rvalue RPAREN_TOK SEMI_TOK {
    $$ = $3;
    AppendSeq($$, GenInstr(NULL, "addi", "$a0", "$t1", "0"));
    AppendSeq($$, GenInstr(NULL, "li", "$v0", "1", NULL));
    AppendSeq($$, GenInstr(NULL, "syscall", NULL, NULL, NULL));
};
rvalue: factor {
    $$ = $1;
    AppendSeq($$, GenInstr(NULL, "addi", "$t1", "$t2", "0"));
};
rvalue: rvalue add_op factor {
    $$ = $1;
    AppendSeq($$, $3);
    if($2 == PLUS_TOK)
        AppendSeq($$, GenInstr(NULL, "add", "$t1", "$t1", "$t2"));
    if($2 == MINUS_TOK)
        AppendSeq($$, GenInstr(NULL, "sub", "$t1", "$t1", "$t2"));
};
factor: value {
    $$ = $1;
    AppendSeq($$, GenInstr(NULL, "addi", "$t2", "$t3", "0"));
};
factor: factor mul_op value {
    $$ = $1;
    AppendSeq($$, $3);
    if($2 == TIMES_TOK)
        AppendSeq($$, GenInstr(NULL, "mul", "$t2", "$t2", "$t3"));
    if($2 == DIV_TOK)
        AppendSeq($$, GenInstr(NULL, "div", "$t2", "$t2", "$t3"));
};
value: id {
    char *label = strdup("_");
    strcat(label, $1);
    $$ = GenInstr(NULL, "lw", "$t3", label, NULL);
};
value: INT_LIT_TOK {
    $$ = GenInstr(NULL, "li", "$t3", yytext, NULL);
};
value: GET_TOK LPAREN_TOK type RPAREN_TOK {
    if($3->BaseType == IntBaseType) {
        $$ = GenInstr(NULL, "li", "$v0", "5", NULL);
        AppendSeq($$, GenInstr(NULL, "syscall", NULL, NULL, NULL));
        AppendSeq($$, GenInstr(NULL, "addi", "$t3", "$v0", "0"));
    }
    if($3->BaseType == ChrBaseType) {
        $$ = GenInstr(NULL, "li", "$v0", "12", NULL);
        AppendSeq($$, GenInstr(NULL, "syscall", NULL, NULL, NULL));
        AppendSeq($$, GenInstr(NULL, "addi", "$t3", "$v0", "0"));
    }
}
add_op: PLUS_TOK {
    $$ = PLUS_TOK;
};
add_op: MINUS_TOK {
    $$ = MINUS_TOK;
};
mul_op: TIMES_TOK {
    $$ = TIMES_TOK;
};
mul_op: DIV_TOK {
    $$ = DIV_TOK;
};

string: STR_LIT_TOK {
    StringLiteral(yytext);
    
    char label[10];
    sprintf(label, "_STR_%d", StringNum);
    
    $$ = label;
};

bool_op: GREATER_TOK {
    $$ = GREATER_TOK;
}
bool_op: GREATEREQ_TOK {
    $$ = GREATEREQ_TOK;
}
bool_op: LESS_TOK {
    $$ = LESS_TOK;
}
bool_op: LESSEQ_TOK {
    $$ = LESSEQ_TOK;
}
bool_op: EQUAL_TOK {
    $$ = EQUAL_TOK;
}
bool_op: NOTEQUAL_TOK {
    $$ = NOTEQUAL_TOK;
}

statement: WHILE_TOK LPAREN_TOK rvalue bool_op rvalue RPAREN_TOK block SEMI_TOK {
    char *top = GenLabel();
    char *bottom = GenLabel();
    
    // Top of loop
    $$ = GenInstr(top, NULL, NULL, NULL, NULL);
    
    // Evaluate Conditional
    AppendSeq($$, $3);
    AppendSeq($$, GenInstr(NULL, "addi", "$t4", "$t1", "0"));
    AppendSeq($$, $5);
    AppendSeq($$, GenInstr(NULL, "sub", "$t4", "$t4", "$t1"));
    
    // Branch condition  x - y is in $t4
    switch($4) {
        case GREATER_TOK:
            AppendSeq($$, GenInstr(NULL, "blez", "$t4", bottom, NULL));
            break;
        case GREATEREQ_TOK:
            AppendSeq($$, GenInstr(NULL, "bltz", "$t4", bottom, NULL));
            break;
        case LESS_TOK:
            AppendSeq($$, GenInstr(NULL, "bgez", "$t4", bottom, NULL));
            break;
        case LESSEQ_TOK:
            AppendSeq($$, GenInstr(NULL, "bgtz", "$t4", bottom, NULL));
            break;
        case EQUAL_TOK:
            AppendSeq($$, GenInstr(NULL, "beq", "$t4", "$zero", bottom));
            break;
        case NOTEQUAL_TOK:
            AppendSeq($$, GenInstr(NULL, "bne", "$t4", "$zero", bottom));
            break;
    }
    
    
    
    // Perform Loop
    AppendSeq($$, $7);
    // Go back to top
    AppendSeq($$, GenInstr(NULL, "b", top, NULL, NULL));
    // End of loop
    AppendSeq($$, GenInstr(bottom, NULL, NULL, NULL, NULL));
}

block: LBRACE_TOK stmtseq RBRACE_TOK {
    $$ = $2;
}

%%

void yyerror(char *s) {
  char msg[MAXLINE];
  sprintf(msg,"ERROR \"%s\" token: \"%s\"",s,yytext);
  PostMessage(GetCurrentColumn(),msg);
}