Letter	[A-Za-z]
Digit   [0-9]
NZDigit   [1-9]

%{
#include "RDTokens.h"
#include "IOMngr.h"
#define YY_INPUT(buf,result,max_size) \
    { int c = GetSourceChar(); \
        result = (c == EOF) ? YY_NULL : (buf[0] = c, 1); \
    }

//#define INTERACTIVE

#ifdef INTERACTIVE
#define RETURN(token) if(!inComment) printf("TOKEN: %d\n", token);
#endif
#ifndef INTERACTIVE
#define RETURN(token) if(!inComment) return token
#endif

int nest = 0;
bool lineComment = false;
bool inComment = false;
%}

%%
" "|"\t" {}

"/*"    {if(!lineComment){nest+=1;inComment=true;}}
"*/"    {if(!lineComment){nest-=1;if(nest<1){nest=0;inComment=false;}}}
"//"    {if(!inComment){inComment=true;lineComment=true;}}
"\n"    {if(lineComment){lineComment=false; inComment=false;}}

"BEGIN"                         {RETURN(BEGIN_TOK);}
"END"                           {RETURN(END_TOK);}
":="                            {RETURN(ASSIGN_TOK);}
";"                             {RETURN(SEMI_TOK);}
"{"                             {RETURN(LPAREN_TOK);}
"}"                             {RETURN(RPAREN_TOK);}
"+"                             {RETURN(PLUS_TOK);}
"-"                             {RETURN(MINUS_TOK);}
"*"                             {RETURN(TIMES_TOK);}
"/"                             {RETURN(DIV_TOK);}
"-"?{NZDigit}{Digit}*           {RETURN(INTLIT_TOK);}
"-"?(({NZDigit}{Digit}*)|0)"."{NZDigit} {RETURN(REALLIT_TOK);}
{Letter}({Letter}|{Digit})*     {RETURN(IDENT_TOK);}
.           			{}
%%

