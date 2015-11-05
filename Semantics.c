/* Semantics.c
   Support and semantic action routines.
   
*/

#include <string.h>

#include "Semantics.h"

/* The main identifier symbol table */
struct SymTab * IdentSymTab;

char *BaseTypeNames[2] = {"Int", "Char"};

/* Semantics support routines */
void
InitSemantics()
{
  IdentSymTab = CreateSymTab(100);
}

void
ListSymTab()
{ int i;
  struct SymEntry * AnEntry;
  char buf[256];
  
  // Could shift this to go to the listing file instead of stdout.
  fprintf(stdout,"\nSymbol Table Contents\n");
  fprintf(stdout,"Num         ID Name  Type\n");
  AnEntry = FirstEntry(IdentSymTab);
  i = 1;
  while (AnEntry) {
    fprintf(stdout,"%3d %15s %5s\n",
                i, GetName(AnEntry),
                BaseTypeNames[((struct Attr *) GetAttr(AnEntry))->TypeDesc->BaseType]);
    i++;
    AnEntry = NextEntry(IdentSymTab,AnEntry);
  }
}

/* Semantic Actions */
struct IdList *   
ProcUndId(char * IdText)
{
}

struct IdList *   
ChainUndId(struct IdList * TheList, char * IdText) 
{
}

struct InstrSeq *
ProcDecl(struct IdList * TheList, struct TypeDesc * TheType) 
{
}

struct TypeDesc * 
ProcTypeDesc(enum BaseTypes TheBaseType) 
{
}

void
Finish(struct InstrSeq * DeclsCode, struct InstrSeq * BodyCode)
{
  printf("Finish\n");
  
  ListSymTab();
  
  struct InstrSeq * finalCode;
  
  finalCode = GenInstr(NULL,".data",NULL,NULL,NULL);
  AppendSeq(finalCode,DeclsCode);
  
  WriteSeq(finalCode);
  
  // write code sequences out to the assembly file
  // this will boilerplate for text and data segment headers and alignment information
  
  // there should be only one call to WriteSeq with entire program since WriteSeq closes the
  // file handle when done
  
  // Choice: generate data segment statements for variables as they are declared, pass up through
  // DeclsCode and concatenate with remainder of code or enumerate symbol table now and generate
  // data segment statement for variables
  
}
