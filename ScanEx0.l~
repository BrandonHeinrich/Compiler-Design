
Letter	[A-Za-z]
Digit	[0-9]

%%

BEGIN			{ printf("// Reserved word \"BEGIN\"//\n"); }
{Digit}(,{Digit})*	{ printf("Seq of digits\n"); }
{Letter}{Letter}*	{ printf("Identifier\n"); }
[ \t\n]			{ }
.			{ }

%%


