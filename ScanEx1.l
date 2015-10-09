%{
  int Factorial(int);
  int TheCnt = 0;
%}

Letter	[A-Za-z]
Digit   [0-9]

%%
[Tt]he				{ TheCnt++; printf("Seen %d \"the\"\'s\n",TheCnt); }
{Letter}{Letter}*		{ printf("Identifier \"%s\"\n",yytext); }
{Digit}+			{ printf("Factorial(%d) = %d\n", atoi(yytext),Factorial(atoi(yytext))); }
[ \t\n] 			{ printf("White space\n"); }
.				{ printf("Something else\n"); }
%%

int
Factorial(int ANumber) 
{ int ret;

  ret = 1;
  for ( ; ANumber > 1; ANumber--) ret *= ANumber;
	
	return ret;
}
