%{
  void camel(char* string, int length);
%}

Upper	[A-Z]
Lower	[a-z]
Digit   [0-9]

%%

{Lower}+({Upper}{Lower}+)*		{camel(yytext, yyleng);}
{Lower}+({Upper}{Lower}+)*{Upper}	{camel(yytext, yyleng);}
({Lower}|{Upper})+			{}
.					{}
%%

void camel(char* string, int length) {
	printf("Identifier Found: ");
	while(length > 0) {
		length -= 1;
		putchar(string[length]);
	}
	putchar('\n');
}

