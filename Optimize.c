#include <string.h>

#include "Optimize.h"

void Optimize(struct InstrSeq *input) {
    RemoveRedundantMoveStatements(input);
    RemoveUnneededLabels(input);
}


void RemoveRedundantMoveStatements(struct InstrSeq *input) {
    // Iterate Through All Instructions
    struct InstrSeq *current = input;
    while(current != NULL) {
        int goToNext = 0;
        
        if(current->Next != NULL &&
           current->Next->OpCode != NULL &&
           strcmp(current->Next->OpCode, "move") == 0) {
            if(current->Next->Oprnd2 != NULL &&
               current->Oprnd1 != NULL &&
               strcmp(current->Next->Oprnd2, current->Oprnd1) == 0) {
                // If this instruction is saving a result, and then the
                // next instruction is immediately moving it to a second
                // register, just save it to the second register.
                current->Oprnd1 = current->Next->Oprnd1;
                struct InstrSeq *next = current->Next;
                
                // Delete move instruction
                current->Next = current->Next->Next;
                free(next);
                
                goToNext = 1;
            }
        }
        
        if(goToNext == 0) {
            current = current->Next;
        }
    }
}

struct Label {
    char *Name;
    struct Label *Next;
};

void RemoveUnneededLabels(struct InstrSeq *input) {
    // Iterate Through All Instructions
    struct InstrSeq *current = input;
    while(current != NULL) {
        if(current->Next != NULL &&
           current->Next->Label != NULL &&
           current->Next->OpCode == NULL) {
            // The next instruction is a label
            if(IsJumpTarget(current->Next->Label, input) == 1) {
                // Not a target, remove it
                struct InstrSeq *next = current->Next;
                current->Next = current->Next->Next;
                free(next);
            }
        }
        current = current->Next;
    }
}

int IsJumpTarget(char *label, struct InstrSeq *input) {
    // Iterate Through All Instructions
    printf("Testing: %s\n", label);
    int line = 1;
    struct InstrSeq *current = input;
    while(current != NULL) {
        if(current->OpCode != NULL) {
            if(strcmp(current->OpCode, "j") == 0 ||
               strcmp(current->OpCode, "b") == 0 ||
               strcmp(current->OpCode, "jal") == 0) {
                if(strcmp(current->Oprnd1, label) == 0) {
                    return 0;
                }
            }
            if(strcmp(current->OpCode, "bgez") == 0 ||
               strcmp(current->OpCode, "bgtz") == 0 ||
               strcmp(current->OpCode, "blez") == 0 ||
               strcmp(current->OpCode, "bltz") == 0) {
                if(strcmp(current->Oprnd2, label) == 0) {
                    return 0;
                }
            }
            if(strcmp(current->OpCode, "beq") == 0 ||
               strcmp(current->OpCode, "bne") == 0) {
                if(strcmp(current->Oprnd3, label) == 0) {
                    return 0;
                }
            }
        }
        current = current->Next;
        line += 1;
    }
    printf("No incoming jumps\n");
    return 1;
}