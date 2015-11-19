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

char *yyval;

#include "QGrammar.h"
%}

%%
";"             {return SEMI_TOK;}
" "|"\t"|"\n"   {}
"main"          {return MAIN_TOK;}
"{"             {return LBRACE_TOK;}
"}"             {return RBRACE_TOK;}
"int"           {return INT_TOK;}
"char"          {return CHAR_TOK;}
","             {return COMMA_TOK;}
{Letter}*       {return IDENT_TOK;}

.           {PostMessage(GetCurrentColumn(), "UNKNOWN CHARACTER");}

%%