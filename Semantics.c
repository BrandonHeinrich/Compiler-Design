/* Semantics.c
   Support and semantic action routines.
   
*/

#include <string.h>

#include "Semantics.h"

/* The main identifier symbol table */
struct SymTab *IdentSymTab;

char *BaseTypeNames[2] = {"Int", "Char"};

/* Semantics support routines */
void InitSemantics() {
    IdentSymTab = CreateSymTab(100);
}

void ListSymTab() {
    int i;
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
struct IdList *ProduceIdentifier(char * IdText) {
    // Create a new IdList
    struct IdList *result = malloc(sizeof(struct IdList));
    // Add name to symbol table
    EnterName(IdentSymTab, IdText, &(result->TheEntry));
    // Not linked
    result->Next = NULL;
    // Return IdList
    return result;
}

struct IdList *ChainIdentifier(struct IdList *TheList, char *IdText) {
    // Create a new IdList
    struct IdList *result = malloc(sizeof(struct IdList));
    // Add name to symbol table
    EnterName(IdentSymTab, IdText, &(result->TheEntry));
    // Link it to next list
    result->Next = TheList;
    // Return IdList
    return result;
}

struct InstrSeq *ProcDecl(struct IdList *TheList, struct TypeDesc *TheType) {
    struct InstrSeq* declaration = NULL;
    while(TheList != NULL) {
        printf("Looping for (%s)\n", TheList->TheEntry->name);
        
        struct InstrSeq* temp = malloc(sizeof(struct InstrSeq));
        temp->Next = declaration;
        declaration = temp;
        declaration->Label = strdup("_");
        strcat(declaration->Label, TheList->TheEntry->name);
        declaration->OpCode = strdup(".word");
        declaration->Oprnd1 = strdup("0");
        declaration->Oprnd2 = NULL;
        declaration->Oprnd3 = NULL;
        
        TheList = TheList->Next;
    }
    printf("\n");
    
    return declaration;
}

struct TypeDesc *ProcTypeDesc(enum BaseTypes TheBaseType) {
    struct TypeDesc *result = malloc(sizeof(struct TypeDesc));
    result->BaseType = TheBaseType;
    return result;
}

void Finish(struct InstrSeq * DeclsCode, struct InstrSeq * BodyCode) {
    printf("Finish\n");
    
    //ListSymTab();
    
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
    DestroySymTab(IdentSymTab);
}
