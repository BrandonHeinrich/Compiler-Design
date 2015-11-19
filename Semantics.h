/* Semantics.h
   The action and supporting routines for performing semantics processing.
*/

#include "SymTab.h"
#include "IOMngr.h"
#include "Scanner.h"
#include "CodeGen.h"

/* Declaration of semantic record data types used in grammar.y %union */
struct IdList {
  struct SymEntry * TheEntry;
  struct IdList * Next;
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
  struct TypeDesc * TypeDesc;
  char * Label;
  /* memory location */
};

/* Supporting Routines */
void InitSemantics();
void ListSymTab();

/* Semantics Actions */
struct IdList *ProcUndId(char * IdText);
struct IdList *ChainUndId(struct IdList *TheList, char *IdText);
struct InstrSeq *ProcDecl(struct IdList *TheList, struct TypeDesc *TheType);
struct TypeDesc *ProcTypeDesc(enum BaseTypes TheBaseType);
void Finish(struct InstrSeq *DeclsCode, struct InstrSeq *BodyCode);