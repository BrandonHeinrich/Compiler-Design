/* Recursive Descent Support Functions */
#include <strings.h>
#include <stdbool.h>

#include "RDSupport.h"
#include "Scanner.h"
#include "IOMngr.h"

int CurToken;
int Failed = 0;

void
Enter(char *Name)
{
  printf("Entering %s\n",Name);
}

void
Leave(char *Name)
{
  printf("Leaving %s\n",Name);
}

void
WriteCallStack()
{
}

void 
ParseError(char *Message)
{ char buf[16];

  PostMessage(GetCurrentColumn(),Message);
	sprintf(buf,"CurToken: %d\n",CurToken);
	PostMessage(GetCurrentColumn(),buf);
}

bool 
Match(int ExpectedToken)
{
  if (CurToken == ExpectedToken) {
    CurToken = yylex();
    return true;
  }
  else {
    if (!Failed) ParseError("Token Match Failed");
		Failed = true;
    return false;
  }
}

