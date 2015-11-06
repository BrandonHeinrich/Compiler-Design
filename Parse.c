#include <string.h>

#include "Scanner.h"
#include "IOMngr.h"
#include "RDTokens.h"
#include "Grammar.h"

int main(int argc, char *argv[]) {
  char SourceName[256];
  char ListingName[256];
  
  if (argc == 2) {
    strcpy(SourceName,"io/input/");
    strcpy(ListingName,"io/output/");
    strcat(SourceName,argv[1]);
    strcat(ListingName,argv[1]);
    strcat(SourceName,".src");
    strcat(ListingName,".lst");
    if (!OpenFiles(SourceName,ListingName)) {
       printf("Source File Not Found.\n");
       exit(1);
    }
    if (yyparse() == 0) {
      PostMessage(GetCurrentColumn(), "Parse Successful");
    }
    else {
      PostMessage(GetCurrentColumn(), "Parse Unsuccessful");
    }
    CloseFiles();
  } else {
    printf("Usage: Parse base-filename\n");
  }
  
  exit(0);
}
