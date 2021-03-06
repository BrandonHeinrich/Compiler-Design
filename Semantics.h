#ifndef __SEMANTICS__H__
#define __SEMANTICS__H__
/* Semantics.h
   The action and supporting routines for performing semantics processing.
*/

#include "SymTab.h"
#include "IOMngr.h"
#include "Scanner.h"
#include "CodeGen.h"

int StringNum;

/* Declaration of semantic record data types used in grammar.y %union */
struct IdList {
  struct SymEntry *TheEntry;
  struct IdList *Next;
};

enum BaseTypes {
  IntBaseType,
  ChrBaseType
};

struct TypeDesc {
  enum BaseTypes BaseType;
};

/* Attribute Structure for symbol table entries */
struct Attr {
  struct TypeDesc *TypeDesc;
  char *Label;
  /* memory location */
};

/* Supporting Routines */
void InitSemantics();
void ListSymTab();

/* Semantics Actions */
struct IdList *ProduceIdentifier(char * IdText);
struct IdList *ChainIdentifier(struct IdList *TheList, char *IdText);
struct InstrSeq *ProcDecl(struct IdList *TheList, struct TypeDesc *TheType);
struct TypeDesc *ProcTypeDesc(enum BaseTypes TheBaseType);
void Finish(struct InstrSeq *DeclsCode, struct InstrSeq *BodyCode);

void StringLiteral(char *String);

struct InstrSeq *Preserve(char* reg, struct InstrSeq *body);

struct InstrSeq *WhileLoop(struct InstrSeq *condition, struct InstrSeq *body);

void EnterBlock();
struct InstrSeq *ExitBlock();
struct InstrSeq *GetBreakTarget();



#endif