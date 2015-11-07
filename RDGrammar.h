/* RDGrammar.h
Contains the grammar parsing routines for the grammar
     
                                                Select Set
<Prog>    :== BEGIN <StmtSeq> END         					
<StmtSeq> :== <Stmt> <StmtSeq>	                Ident
<StmtSeq> :== 				                    END
<Stmt>	  :== <Ident> := <Expr> ;
<Expr>	  :== <Term> <MExpr>
<MExpr>	  :== <AddOp> <Term> <MExpr>            - +
<MExpr>	  :==                                   ; )
<Term>	  :== <Factor> <MTerm>
<MTerm>	  :== <MultOp> <Factor> <MTerm>         * /
<MTerm>	  :==                                   - + ; )
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

#include "RDSupport.h"

/* Nonterminal Functions */
bool Prog();
bool StmtSeq();
bool Stmt();
bool Expr();
bool MExpr();
bool Term();
bool MTerm();
bool Factor();
bool AddOp();
bool MultOp();

