/* SymTabDriver.c

   This program minimally exercises the Symbol Table implementation.

*/
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>
#include "SymTab.h"

/* A name's attributes consist of two integers. */
struct Attributes {
  int value1, value2;
};

int
main(int argc, char **argv)
{ FILE *fd;
  struct SymTab *theTable, *copyTable;
  struct SymEntry *anEntry, *copyEntry;
  struct Attributes *anAttr;
  char buffer[16];
  int val1, val2, i;

  /* Create a table of appoximately size 10. */
  theTable = CreateSymTab(5);
	
	/* open input file */
	fd = fopen("SymData.txt","r"); 
	if (!fd) {
	  fprintf(stdout,"Can't open input file.\n");
		exit(1);
	}
  
  /* Read lines consisting of a name string a integer from std input. 
     if already present increment Value2, if newly entered allocate
     storage for attribute structure and fill in fields.
  */
  while (fscanf(fd,"%15s %d",buffer,&val1) != EOF) {
    printf("Find: %15s ",buffer);
    if (FindName(theTable,buffer)) {
      fprintf(stdout," Present     -");
    }
    else {
      fprintf(stdout," Not Present -");
    }
    if (EnterName(theTable,buffer,&anEntry)) {
      fprintf(stdout,"  Enter: Present: %15s\n",GetName(anEntry));
      ((struct Attributes *) GetAttr(anEntry))->value2++;
    }
    else {
      fprintf(stdout,"  Enter: Entered: %15s\n",GetName(anEntry));
      anAttr = malloc(sizeof(struct Attributes));
      anAttr->value1 = val1;
      anAttr->value2 = 1;
      SetAttr(anEntry,anAttr);
    }
  }
  
  struct Stats * stats = Statistics(theTable);
  fprintf(stdout,"Statistics min: %d max: %d avg: %d total: %d\n",
          stats->minLen,stats->maxLen,stats->avgLen,stats->entryCnt);
  
  /* Enumerate the contents of TheTable. Create CopyTable and enter
     names as enumerated. Set attribute pointer in CopyTable to same
     value as in TheTable.
  */
  fprintf(stdout,"\nContents of Original Table\n");
  copyTable = CreateSymTab(3);
  anEntry = FirstEntry(theTable);
  i = 1;
  while (anEntry) {
    EnterName(copyTable,GetName(anEntry),&copyEntry);
    SetAttr(copyEntry,GetAttr(anEntry));
    fprintf(stdout,"%3d %15s %5d %5d\n", i, 
           GetName(anEntry),
           ((struct Attributes *) GetAttr(anEntry))->value1,
           ((struct Attributes *) GetAttr(anEntry))->value2);
    i++;
    anEntry = NextEntry(theTable, anEntry);
  }
  
  /* Destroy original table. */
  DestroySymTab(theTable);
  
  /* Enumerate the contents of CopyTable. */
  fprintf(stdout,"\nContents of Copy Table\n");
  anEntry = FirstEntry(copyTable);
  i = 1;
  while (anEntry) {
    fprintf(stdout,"%3d %20s %5d %5d\n", i, 
           GetName(anEntry),
           ((struct Attributes *) GetAttr(anEntry))->value1,
           ((struct Attributes *) GetAttr(anEntry))->value2);
    i++;
    free(GetAttr(anEntry));
    anEntry = NextEntry(copyTable, anEntry);
  }
  
  stats = Statistics(copyTable);
  fprintf(stdout,"Statistics min: %d max: %d avg: %d total: %d\n",
          stats->minLen,stats->maxLen,stats->avgLen,stats->entryCnt);
  
  /* Destroy CopyTable. */
  DestroySymTab(copyTable);
  
  exit(0);
} 
