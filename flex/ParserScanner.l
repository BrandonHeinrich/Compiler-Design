Letter  [A-Za-z]
Digit   [0-9]
NZDigit [1-9]

%{
#include <string.h>


#include "IOMngr.h"

#define YY_INPUT(buf,result,max_size) \
    { int c = GetSourceChar(); \
        result = (c == EOF) ? YY_NULL : (buf[0] = c, 1); \
    }

#define RETURN(token) if(!inComment) return token

char *yyval;
#include "ParserGrammar.h"

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
"("                             {RETURN(LPAREN_TOK);}
")"                             {RETURN(RPAREN_TOK);}
"+"                             {RETURN(PLUS_TOK);}
"-"                             {RETURN(MINUS_TOK);}
"*"                             {RETURN(TIMES_TOK);}
"/"                             {RETURN(DIV_TOK);}
"-"?{NZDigit}{Digit}*           {RETURN(INTLIT_TOK);}
{Letter}({Letter}|{Digit})*     {RETURN(IDENT_TOK);}
.           		            {}

%%

