Letter	[A-Za-z]
Digit   [0-9]

%{
#include "Tokens.h"
#include "IOMngr.h"
#define YY_INPUT(buf,result,max_size) \
	{ int c = GetSourceChar(); \
		result = (c == EOF) ? YY_NULL : (buf[0] = c, 1); \
	}

int nest = 0;
bool lineComment = false;
bool inComment = false;
%}

%%
"/*"				{if(!lineComment){nest+=1;inComment=true;}}
"*/"				{if(!lineComment){nest-=1;if(nest<1){nest=0;inComment=false;}}}
"//"				{if(!inComment){inComment=true;lineComment=true;}}
"\n"				{if(lineComment){lineComment=false; inComment=false;}}

\$INIT                          {if(!inComment) return INIT_TOK;}
\$DUMP                          {if(!inComment) return DUMP_TOK;}

{Letter}({Letter}|{Digit})*	{if(!inComment) return IDENT_TOK;}

{Digit}+			{if(!inComment) return INTEGER_TOK;}
{Digit}+\.{Digit}+		{if(!inComment) return FLOAT_TOK;}

\{				{if(!inComment) return LEFT_PAREN_TOK;}
\}				{if(!inComment) return RIGHT_PAREN_TOK;}

[ \t\n]                         {}
.                               {}
%%


