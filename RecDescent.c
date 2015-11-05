/* Main of Recursive Descent Parser */

#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>

#include "Scanner.h"
#include "IOMngr.h"
#include "Tokens.h"

#include "RDSupport.h"
#include "RDGrammar.h"

int
main(int argc, char * argv[])
{ char SourceName[256], ListingName[256];
  
  if (argc == 2) {
    strcpy(SourceName, "io/input/");
    strcpy(ListingName, "io/output/");
    strcat(SourceName,argv[1]);
    strcat(ListingName,argv[2]);
    strcat(SourceName,".src");
    strcat(ListingName,".lst");
    OpenFiles(SourceName,ListingName);
    CurToken = yylex();
    if (Prog()) {
      PostMessage(GetCurrentColumn(), "Parse Successful");
    }
    else {
      PostMessage(GetCurrentColumn(), "Parse Unsuccessful");
			WriteCallStack();
    }
    CloseFiles();
  }
  else {
    printf("Usage: RecDescent filename\n");
  }
  
  exit(0);
}
