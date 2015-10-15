#include <stdbool.h>

#include "IOMngr.h"
#include "RDGrammar.h"
#include "RDTokens.h"

// <Prog> :== BEGIN <StmtSeq> END	
bool Prog() {
    Enter("Prog");
	
    if(!Match(BEGIN_TOK)) return false;
    if(!StmtSeq()) return false;
    if(!Match(END_TOK)) return false;
	
    Leave("Prog");
    return true;
}

// <StmtSeq> :== <Stmt> <StmtSeq>	
// <StmtSeq> :==	
bool StmtSeq() {
    Enter("StmtSeq");
    
    switch(CurToken) {
        case END_TOK:
            break;
        case IDENT_TOK:
            if(!Stmt()) return false;
            if(!StmtSeq()) return false;
            break;
    }

    Leave("StmtSeq");
    return true;
}

// <Stmt> :== <Ident> := <Expr> ;	
bool Stmt() {
    Enter("Stmt");
    
    if(!Match(IDENT_TOK)) return false;
    if(!Match(ASSIGN_TOK)) return false;
    if(!Expr()) return false;
    if(!Match(SEMI_TOK)) return false;

    Leave("Stmt");
    return true;
}

// <Expr> :== <Term> <MExpr>	
bool Expr() {
    Enter("Expr");

    if(!Term()) return false;
    if(!MExpr()) return false;    

    Leave("Expr");
    return true;
}

// <MExpr> :== <AddOp> <Term> <MExpr>	
// <MExpr> :== 
bool MExpr() {
    Enter("MExpr");

    switch(CurToken) {
        case PLUS_TOK:
        case MINUS_TOK:
            if(!AddOp()) return false;
            if(!Term()) return false;
            if(!MExpr()) return false;
            break;
        case SEMI_TOK:
        case RPAREN_TOK:
            break;
    }

    Leave("MExpr");
    return true;
}

//<Term> :== <Factor> <MTerm>	
bool Term() {
    Enter("Term");

    if(!Factor()) return false;
    if(!MTerm()) return false;

    Leave("Term");
    return true;
}

//<MTerm> :== <MultOp> <Factor> <MTerm>
//<MTerm> :==
bool MTerm() {
    Enter("MTerm");
    
    switch(CurToken) {
        case TIMES_TOK:
        case DIV_TOK:
            if(!MultOp()) return false;
            if(!Factor()) return false;
            if(!MTerm()) return false;
            break;
        case PLUS_TOK:
        case MINUS_TOK:
        case SEMI_TOK:
        case RPAREN_TOK:
            break;
    }
    
    Leave("MTerm");
    return true;
}

// <Factor>	:==	( <Expr> )		
// <Factor>	:==	- <Factor>		
// <Factor>	:==	<IntLit>		
// <Factor>	:==	<RealLit>		
// <Factor>	:==	<Ident>	
bool Factor() {
    Enter("Factor");
    
    switch(CurToken) {
        case LPAREN_TOK:
            if(!Match(LPAREN_TOK)) return false;
            if(!Expr()) return false;
            if(!Match(RPAREN_TOK)) return false;
            break;
        case MINUS_TOK:
            if(!Match(MINUS_TOK)) return false;
            if(!Factor()) return false;
            break;
        case INTLIT_TOK:
            if(!Match(INTLIT_TOK)) return false;
            break;
        case REALLIT_TOK:
            if(!Match(REALLIT_TOK)) return false;
            break;
        case IDENT_TOK:
            if(!Match(IDENT_TOK)) return false;
            break;
    }
    
    Leave("Factor");
    return true;
}

// <AddOp> :== -			
// <AddOp> :== +
bool AddOp() {
    Enter("AddOp");
    switch(CurToken) {
        case PLUS_TOK:
            if(!Match(PLUS_TOK)) return false;
            break;
        case MINUS_TOK:
            if(!Match(MINUS_TOK)) return false;
            break;
    }
    Leave("AddOp");
    return true;
}

// <MultOp>	:==	*		
// <MultOp>	:==	/
bool MultOp() {
    Enter("MultOp");
    switch(CurToken) {
        case TIMES_TOK:
            if(!Match(TIMES_TOK)) return false;
            break;
        case DIV_TOK:
            if(!Match(DIV_TOK)) return false;
            break;
    }
    Leave("MultOp");
    return true;
}

