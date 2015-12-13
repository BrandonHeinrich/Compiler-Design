#ifndef __OPTIMIZE_H__
#define __OPTIMIZE_H__

#include "CodeGen.h"
#include <stdlib.h>

void Optimize(struct InstrSeq *input);

void RemoveRedundantMoveStatements(struct InstrSeq *input);
void RemoveUnneededLabels(struct InstrSeq *input);
int IsJumpTarget(char *label, struct InstrSeq *input);

#endif