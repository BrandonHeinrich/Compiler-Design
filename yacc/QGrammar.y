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
%type <InstrSeq> bvalue
%type <Operation> add_op
%type <Operation> mul_op
%type <Operation> bool_op

%type <InstrSeq> case
%type <InstrSeq> caselist
%type <InstrSeq> extracase


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
%token FOR_TOK
%token GREATER_TOK
%token LESS_TOK
%token GREATEREQ_TOK
%token LESSEQ_TOK
%token EQUAL_TOK
%token NOTEQUAL_TOK
%token IF_TOK
%token ELSE_TOK
%token BREAK_TOK

%token SWITCH_TOK
%token COLON_TOK
%token CASE_TOK
%token DEFAULT_TOK

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
    
    PostMessage(GetCurrentColumn(), "End of Statement");
};
statement: PUT_TOK LPAREN_TOK string RPAREN_TOK SEMI_TOK {
    $$ = GenInstr(NULL, "li", "$v0", "4", NULL);
    AppendSeq($$, GenInstr(NULL, "la", "$a0", $3, NULL));
    AppendSeq($$, GenInstr(NULL, "syscall", NULL, NULL, NULL));
    
    PostMessage(GetCurrentColumn(), "End of Statement");
};
statement: PUT_TOK LPAREN_TOK rvalue RPAREN_TOK SEMI_TOK {
    $$ = $3;
    AppendSeq($$, GenInstr(NULL, "move", "$a0", "$t1", NULL));
    AppendSeq($$, GenInstr(NULL, "li", "$v0", "1", NULL));
    AppendSeq($$, GenInstr(NULL, "syscall", NULL, NULL, NULL));
    
    PostMessage(GetCurrentColumn(), "End of Statement");
};
statement: WHILE_TOK LPAREN_TOK bvalue RPAREN_TOK block SEMI_TOK {
    $$ = WhileLoop($3,$5);
    
    PostMessage(GetCurrentColumn(), "End of Statement");
}
statement: IF_TOK LPAREN_TOK bvalue RPAREN_TOK block SEMI_TOK {
    char *endlabel = GenLabel();
    
    $$ = $3;
    AppendSeq($$, GenInstr(NULL, "beq", "$t4", "$zero", endlabel));
    AppendSeq($$, $5);
    AppendSeq($$, GenInstr(endlabel, NULL, NULL, NULL, NULL));
    
    PostMessage(GetCurrentColumn(), "End of Statement");
}
statement: IF_TOK LPAREN_TOK bvalue RPAREN_TOK block ELSE_TOK block SEMI_TOK {
    char *elselabel = GenLabel();
    char *endlabel = GenLabel();
    
    $$ = $3;
    AppendSeq($$, GenInstr(NULL, "beq", "$t4", "$zero", elselabel));
    AppendSeq($$, $5);
    AppendSeq($$, GenInstr(NULL, "b", endlabel, NULL, NULL));
    AppendSeq($$, GenInstr(elselabel, NULL, NULL, NULL, NULL));
    AppendSeq($$, $7);
    AppendSeq($$, GenInstr(endlabel, NULL, NULL, NULL, NULL));
    
    PostMessage(GetCurrentColumn(), "End of Statement");
}
statement: FOR_TOK LPAREN_TOK statement statement bvalue RPAREN_TOK block SEMI_TOK {
    $$ = $3;
    AppendSeq($7, $4);
    AppendSeq($$, WhileLoop($5, $7));
};

statement: BREAK_TOK SEMI_TOK {
    
}

block: LBRACE_TOK stmtseq RBRACE_TOK {
    $$ = $2;
    PostMessage(GetCurrentColumn(), "End of Block");
}

rvalue: factor {
    $$ = $1;
    AppendSeq($$, GenInstr(NULL, "move", "$t1", "$t2", NULL));
    
    //PostMessage(GetCurrentColumn(), "Singular rvalue");
};
rvalue: rvalue add_op factor {
    $$ = $1;
    AppendSeq($$, $3);
    if($2 == PLUS_TOK)
        AppendSeq($$, GenInstr(NULL, "add", "$t1", "$t1", "$t2"));
    if($2 == MINUS_TOK)
        AppendSeq($$, GenInstr(NULL, "sub", "$t1", "$t1", "$t2"));
        
    PostMessage(GetCurrentColumn(), "Compound rvalue");
};
factor: value {
    $$ = $1;
    AppendSeq($$, GenInstr(NULL, "move", "$t2", "$t3", NULL));
    
    PostMessage(GetCurrentColumn(), "Singular factor");
};
factor: factor mul_op value {
    $$ = $1;
    AppendSeq($$, $3);
    if($2 == TIMES_TOK)
        AppendSeq($$, GenInstr(NULL, "mul", "$t2", "$t2", "$t3"));
    if($2 == DIV_TOK)
        AppendSeq($$, GenInstr(NULL, "div", "$t2", "$t2", "$t3"));
        
    PostMessage(GetCurrentColumn(), "Compound factor");
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
        AppendSeq($$, GenInstr(NULL, "move", "$t3", "$v0", NULL));
    }
    if($3->BaseType == ChrBaseType) {
        $$ = GenInstr(NULL, "li", "$v0", "12", NULL);
        AppendSeq($$, GenInstr(NULL, "syscall", NULL, NULL, NULL));
        AppendSeq($$, GenInstr(NULL, "move", "$t3", "$v0", NULL));
    }
}
value: LPAREN_TOK rvalue RPAREN_TOK {
    $$ = $2;
    AppendSeq($$, GenInstr(NULL, "move", "$t3", "$t1", NULL));
    $$ = Preserve("$t1", Preserve("$t2", $$));
};

string: STR_LIT_TOK {
    StringLiteral(yytext);
    
    char label[10];
    sprintf(label, "_STR_%d", StringNum);
    
    $$ = label;
    
    PostMessage(GetCurrentColumn()-strlen(yytext)+1, "StringLiteral");
};

add_op: PLUS_TOK {
    $$ = PLUS_TOK;
    PostMessage(GetCurrentColumn(), "Additive Operator");
};
add_op: MINUS_TOK {
    $$ = MINUS_TOK;
    
    PostMessage(GetCurrentColumn(), "Additive Operator");
};
mul_op: TIMES_TOK {
    $$ = TIMES_TOK;
    
    PostMessage(GetCurrentColumn()-1, "Multiplicitive Operator");
};
mul_op: DIV_TOK {
    $$ = DIV_TOK;
    
    PostMessage(GetCurrentColumn()-1, "Multiplicitive Operator");
};

bool_op: GREATER_TOK {
    $$ = GREATER_TOK;
    
    PostMessage(GetCurrentColumn()-1, "Boolean Operator");
}
bool_op: GREATEREQ_TOK {
    $$ = GREATEREQ_TOK;
    
    PostMessage(GetCurrentColumn()-2, "Boolean Operator");
}
bool_op: LESS_TOK {
    $$ = LESS_TOK;
    
    PostMessage(GetCurrentColumn()-1, "Boolean Operator");
}
bool_op: LESSEQ_TOK {
    $$ = LESSEQ_TOK;
    
    PostMessage(GetCurrentColumn()-2, "Boolean Operator");
}
bool_op: EQUAL_TOK {
    $$ = EQUAL_TOK;
    
    PostMessage(GetCurrentColumn()-2, "Boolean Operator");
}
bool_op: NOTEQUAL_TOK {
    $$ = NOTEQUAL_TOK;
    
    PostMessage(GetCurrentColumn()-2, "Boolean Operator");
}

bvalue: rvalue bool_op rvalue {
    // Evaluate Conditional
    $$ = $1;
    AppendSeq($$, GenInstr(NULL, "move", "$t4", "$t1", NULL));
    AppendSeq($$, $3);
    
    // Branch condition  x - y is in $t4
    switch($2) {
        case GREATER_TOK:
            AppendSeq($$, GenInstr(NULL, "sgt", "$t4", "$t4", "$t1"));
            break;
        case GREATEREQ_TOK:
            AppendSeq($$, GenInstr(NULL, "sge", "$t4", "$t4", "$t1"));
            break;
        case LESS_TOK:
            AppendSeq($$, GenInstr(NULL, "slt", "$t4", "$t4", "$t1"));
            break;
        case LESSEQ_TOK:
            AppendSeq($$, GenInstr(NULL, "sle", "$t4", "$t4", "$t1"));
            break;
        case EQUAL_TOK:
            AppendSeq($$, GenInstr(NULL, "seq", "$t4", "$t4", "$t1"));
            break;
        case NOTEQUAL_TOK:
            AppendSeq($$, GenInstr(NULL, "sne", "$t4", "$t4", "$t1"));
            break;
    }
}


statement: SWITCH_TOK LPAREN_TOK rvalue RPAREN_TOK COLON_TOK caselist SEMI_TOK {
    // Store the value of the switch constant in register $t5
    $$ = $3;
    AppendSeq($$, GenInstr(NULL, "move", "$t5", "$t1", NULL));
    
    // Append the cases
    AppendSeq($$, $6);
    
    $$ = Preserve("$t5", $$);
}
caselist: case extracase {
    $$ = $1;
    AppendSeq($$, $2);
}
extracase: case extracase {
    $$ = $1;
    AppendSeq($$, $2);
}
extracase: {
    $$ = NULL;
}
case: CASE_TOK LPAREN_TOK rvalue RPAREN_TOK block {
    char *end_label = GenLabel();
    
    // Calculate the rvalue
    $$ = $3;
    
    // Skip to next case if $t1 and $t5 are not equal
    AppendSeq($$, GenInstr(NULL, "bne", "$t1", "$t5", end_label));
    
    // If theyre equal, execute the body
    AppendSeq($$, $5);
    
    // Label for the start of the next case
    AppendSeq($$, GenInstr(end_label, NULL, NULL, NULL, NULL));
}
case: DEFAULT_TOK block {
    // Just Run the block
    $$ = $2;
}





%%

void yyerror(char *s) {
  char msg[MAXLINE];
  sprintf(msg,"ERROR \"%s\" token: \"%s\"",s,yytext);
  PostMessage(GetCurrentColumn(),msg);
}