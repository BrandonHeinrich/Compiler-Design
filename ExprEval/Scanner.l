Letter [A-Za-z]
Digit [0-9]

%%
BEGIN    		{  return 1; }
END      		{  return 2; }
{Letter}+ 	{  return 3; }
{Digit}+ 		{  return 4; }
\=       		{  return 5; }
\+       		{  return 6; }
\-       		{  return 7; }
\*       		{  return 8; }
\/       		{  return 9; }
\(       		{  return 10; }
\)       		{  return 11; }
\;       		{  return 12; }

[ \n\t]		{ }
.					{ }
%%

