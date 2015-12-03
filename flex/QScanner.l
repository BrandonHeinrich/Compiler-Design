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

int nest = 0;
bool lineComment = false;
bool inComment = false;
#define RETURN if(!inComment) return
%}

%%
" "|"\t" {}

"/*"    {if(!lineComment){nest+=1;inComment=true;}}
"*/"    {if(!lineComment){nest-=1;if(nest<1){nest=0;inComment=false;}}}
"//"    {if(!inComment){inComment=true;lineComment=true;}}
"\n"    {if(lineComment){lineComment=false; inComment=false;}}

";"                 {RETURN SEMI_TOK;}
"="                 {RETURN ASSIGN_TOK;}
"+"                 {RETURN PLUS_TOK;}
"-"                 {RETURN MINUS_TOK;}
"*"                 {RETURN TIMES_TOK;}
"/"                 {RETURN DIV_TOK;}

">"                 {RETURN GREATER_TOK;}
">="                 {RETURN GREATEREQ_TOK;}
"<"                 {RETURN LESS_TOK;}
"<="                 {RETURN LESSEQ_TOK;}
"=="                 {RETURN EQUAL_TOK;}
"!="                 {RETURN NOTEQUAL_TOK;}

"main"              {RETURN MAIN_TOK;}
"while"             {RETURN WHILE_TOK;}
"get"               {RETURN GET_TOK;}
"put"               {RETURN PUT_TOK;}

"{"                 {RETURN LBRACE_TOK;}
"}"                 {RETURN RBRACE_TOK;}
"("                 {RETURN LPAREN_TOK;}
")"                 {RETURN RPAREN_TOK;}
"int"               {RETURN INT_TOK;}
"char"              {RETURN CHAR_TOK;}
","                 {RETURN COMMA_TOK;}
{Letter}*           {RETURN IDENT_TOK;}
{Digit}*            {RETURN INT_LIT_TOK;}
\"(\\.|[^\\"])*\"   {RETURN STR_LIT_TOK;}

.           {PostMessage(GetCurrentColumn(), "UNKNOWN CHARACTER");}

%%