/* ScannerDriver.c

*/
#include <stdio.h>
#include <string.h>

#include "Tokens.h"

#include "SymTab.h"
#include "IOMngr.h"
#include "Scanner.h"

/* symbol table entries have two attributes, first line of occurrence and occurrence count */
struct Attributes {
  int firstLine;
  int cnt;
};

/* used with qsort to sort list of symbol table entries */
int
entryCmp(const void * A, const void * B)
{
  /* A is pointer to element of array which contains a pointer to a struct SymEntry */
  const char * strA = GetName(*(struct SymEntry **)A);
  const char * strB = GetName(*(struct SymEntry **)B);
  return strcmp(strA,strB);
}

int
main(int argc, char **argv)
{ int Token;
  char message[256];
  struct SymTab * table = NULL;
  
  bool ret = OpenFiles("io/input/ScannerSource", "io/output/ScannerListing");
  if (!ret) {
    printf("Could not open source and listing files\n");
    exit(1);
  }
  int loops = 0;
  while ((Token = yylex()) != 0 && loops < 10000) {
	loops += 1;
    sprintf(message,"Token#=%d, Length=%d, Text=\"%s\"",Token,yyleng,yytext);
    PostMessage(GetCurrentColumn()-yyleng,message);
    switch(Token) {
      case INIT_TOK: {
	//printf("INIT_TOK\n");
        /* create a symbol table 
         */
        if (!table) table = CreateSymTab(20);
        break; }
      case IDENT_TOK: {
	//printf("IDENT_TOK\n");
        /* place the identifier in the table (if it exists), if new then create and init
           attributes structure, if already in table then update attributes cnt field, in
           either case post an appropriate message
         */
	if(table) {
		struct SymEntry *entry = NULL;
		char *text = malloc(sizeof(char)*yyleng+1);
		
		// Make "text" be a pointer to a null terminated string containing the text of the token.
		strncpy(text, yytext, yyleng);
		text[yyleng] = '\0';

		if(!EnterName(table, text, &entry)) {
			// Just Added to table
			struct Attributes *attr = malloc(sizeof(struct Attributes));
			(*attr).firstLine = GetCurrentLine();
			(*attr).cnt = 0;
			(*entry).attributes = attr;
		}
		
		struct Attributes *attr = (*entry).attributes;
		(*attr).cnt += 1;

		free(text);
	}
       break; }
      /* cases for other token types
       */
      case DUMP_TOK: {
	//printf("DUMP_TOK\n");
        /* get table statistics, alloc an array to hold entry pointers
         */
        struct Stats * stats = Statistics(table);
        struct SymEntry ** entries = malloc(stats->entryCnt * sizeof(struct SymEntry *));
        
        /* enumerate the table collecting entry pointers into the array
         */
        int i = 0;
        struct SymEntry * entry = FirstEntry(table);
        entries[i] = entry;
        while (entry) {
          i++;
          entry = NextEntry(table, entry);
          entries[i] = entry;
        }

        /* sort the entries
         */
        qsort(entries,stats->entryCnt,sizeof(struct SymEntry *),entryCmp);
        
        /* list the contents of the table in sorted order
         */
        printf("\nContents of Symbol Table\n");
        for (i = 0; i < stats->entryCnt; i++) {
          printf("%3d %20s %5d %5d\n", i,
                 GetName(entries[i]),
                 ((struct Attributes *) GetAttr(entries[i]))->firstLine,
                 ((struct Attributes *) GetAttr(entries[i]))->cnt);
        }
        free(stats);
        break; }
    }
  }
  CloseFiles();
}
