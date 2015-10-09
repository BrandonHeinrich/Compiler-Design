/* Scanner.h
   This is really a convenience wrapper around the function and variables
   supplied by lex.
*/

extern int yylex();	    /* The next token function. */
extern char *yytext;    /* The matched token text.  */
extern int yyleng;      /* The token text length.   */
