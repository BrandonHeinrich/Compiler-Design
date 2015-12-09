/* Semantics.c
   Support and semantic action routines.
   
*/

#include <string.h>

#include "Semantics.h"

/* The main identifier symbol table */
struct SymTab *IdentSymTab;

char *BaseTypeNames[2] = {"Int", "Char"};

struct InstrSeq *Literals = NULL;

/* Semantics support routines */
void InitSemantics() {
    StringNum = 0;
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
    
    // Put Attr in entry
    struct Attr *attributes = malloc(sizeof(struct Attr));
    attributes->Label = strdup(IdText);
    attributes->TypeDesc = malloc(sizeof(struct TypeDesc));
    attributes->TypeDesc->BaseType = IntBaseType;
    SetAttr(result->TheEntry, attributes);
    
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
    
    // Put Attr in entry
    struct Attr *attributes = malloc(sizeof(struct Attr));
    attributes->Label = strdup(IdText);
    attributes->TypeDesc = malloc(sizeof(struct TypeDesc));
    attributes->TypeDesc->BaseType = IntBaseType;
    SetAttr(result->TheEntry, attributes);
    
    // Return IdList
    return result;
}

struct InstrSeq *ProcDecl(struct IdList *TheList, struct TypeDesc *TheType) {
    struct InstrSeq* declaration = NULL;
    
    while(TheList != NULL) {
        // Create Instruction at begin of declaration
        struct InstrSeq* temp = malloc(sizeof(struct InstrSeq));
        temp->Next = declaration;
        declaration = temp;
        
        // Declare fields for instruction
        declaration->Label = strdup("_");
        strcat(declaration->Label, TheList->TheEntry->name);
        declaration->OpCode = strdup(".word");
        declaration->Oprnd1 = strdup("0");
        declaration->Oprnd2 = NULL;
        declaration->Oprnd3 = NULL;
        
        // Set the type of this variable.
        ((struct Attr *) GetAttr(TheList->TheEntry))->TypeDesc = TheType;
        
        // Access the next element in the list
        TheList = TheList->Next;
    }
    
    return declaration;
}

struct TypeDesc *ProcTypeDesc(enum BaseTypes TheBaseType) {
    struct TypeDesc *result = malloc(sizeof(struct TypeDesc));
    result->BaseType = TheBaseType;
    return result;
}

void Finish(struct InstrSeq *DeclsCode, struct InstrSeq *BodyCode) {
    ListSymTab();
    
    struct InstrSeq * finalCode;
    
    finalCode = GenInstr(NULL,".text",NULL,NULL,NULL);
    AppendSeq(finalCode, BodyCode);
    AppendSeq(finalCode, GenInstr(NULL,".data",NULL,NULL,NULL));
    AppendSeq(finalCode, DeclsCode);
    AppendSeq(finalCode, Literals);
    
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








void StringLiteral(char *String) {
    // Create New ID Number For This String
    StringNum += 1;
    
    // Create Label
    char label[10];
    sprintf(label, "_STR_%d", StringNum);
    
    // Create Instruction For String
    struct InstrSeq *temp = GenInstr(label, ".asciiz", String, NULL, NULL);
    
    // Prepend Instructon
    temp->Next = Literals;
    Literals = temp;
}


struct InstrSeq *Preserve(char* reg, struct InstrSeq *body){
    struct InstrSeq *result = GenInstr(NULL, "addiu", "$sp", "$sp", "-4");
    AppendSeq(result, GenInstr(NULL, "sw", reg, "0($sp)", NULL));
    AppendSeq(result, body);
    AppendSeq(result, GenInstr(NULL, "lw", reg, "0($sp)", NULL));
    AppendSeq(result, GenInstr(NULL, "addiu", "$sp", "$sp", "4"));
    
    return result;
}