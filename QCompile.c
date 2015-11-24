#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "CodeGen.h"
#include "IOMngr.h"

extern int yyparse();

int main(int argc, char **argv) {
    char *filename;
    
    char source[255];
    char listing[255];
    char assembly[255];
    
    
    
    if(argc == 2) {
        filename = argv[1];
        
        strcpy(source, "io/input/");
        strcpy(listing, "io/output/");
        strcpy(assembly, "io/output/");
        
        strcat(source, filename);
        strcat(listing, filename);
        strcat(assembly, filename);
        
        strcat(source, ".src");
        strcat(listing, ".lst");
        strcat(assembly, ".asm");
        
        if(!OpenFiles(source, listing)) {
            printf("SOMETHING FUCKED UP\n");
        }
        
        InitCodeGen(assembly);
        InitSemantics();
        
        switch(yyparse()) {
            case 0:
                PostMessage(GetCurrentColumn(), "COMPILATION SUCSESSFUL");
                break;
            case 1:
                PostMessage(GetCurrentColumn(), "COMPILATION FAILED - BAD INPUT");
                printf("COMPILATION FAILED - BAD INPUT\n");
                break;
            case 2:
                PostMessage(GetCurrentColumn(), "COMPILATION FAILED - OUT OF MEMORY");
                printf("COMPILATION FAILED - OUT OF MEMORY\n");
                break;
            default:
                PostMessage(GetCurrentColumn(), "SOMETHING UNEXPECTED HAPPENED");
                printf("SOMETHING UNEXPECTED HAPPENED\n");
                break;
        }
        UpdateListingFile();
    } else {
        printf("Useage: Q <SourceName>");
    }
    
    exit(0);
}