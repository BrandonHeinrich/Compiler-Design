/* IOMngrDriver.c

*/
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "IOMngr.h"

int
main(int argc, char **argv)
{ char curChar;
  char *src, *lst;
  
	if (argc == 1) {
	  src = "io/input/IOMngrSource";
		lst = "io/output/IOMngrListing";
	}
  else if (argc == 2) {
    src = argv[1];
    lst = NULL;
  }
  else if (argc == 3) {
    src = argv[1];
    lst = argv[2];
  }
  else {
    fprintf(stderr,"usage: IOMngrDriver SourceName [ListingName]\n");
    exit(1);
  }
  
  if (OpenFiles(src,lst)) {
    while((curChar = GetSourceChar()) != EOF) {
      if (isupper(curChar)) {
        PostMessage(GetCurrentColumn(),"found uppercase");
      }
      if (strchr("(){}",curChar)) {
        PostMessage(GetCurrentColumn(),"found grouping symbol");
      }
      if (strchr(",;",curChar)) {
        PostMessage(GetCurrentColumn(),"found punctuation");
      }
      if (strchr("=*",curChar)) {
        PostMessage(GetCurrentColumn(),"found operator symbol");
      }
   }
    CloseFiles();
  }
  else {
    printf("Files could not be opened.\n");
  }

  exit(0);
}