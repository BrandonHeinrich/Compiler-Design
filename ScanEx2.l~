%{
  #define STK_SIZE 256
  int stack[STK_SIZE];
  int tos = -1;
  
  void push(int v) {
    if (tos < STK_SIZE-1) stack[++tos] = v;
  }
  
  int pop() {
    return (tos >= 0) ? (stack[tos--]) : (0);
  }
  
%}

Letter	[A-Za-z]
Digit   [0-9]


%%
{Digit}+						{ push(atoi(yytext)); }
\+                  { push(pop() + pop()); }
\-                  { push(-pop() + pop()); }
\*                  { push(pop() * pop()); }
\/                  { push(1.0 / pop() * pop()); }
\=                  { printf("val = %d\n",pop()); }
[ \t\n] 						{ }
.										{ }
%%

