# CS 442 - Compiler Construction
## Semantics Part I

This repository contains files to be addded to your main project repository to include the semantic processing capabilities to compile programs of the language Q. The repository contains

- Q.c
 - This is the test driver for the assignment. This driver takes one argument, the base name of the source and listing files, and opens these files by appending ".src", ".lst" and ".asm" "to the base name. It then starts the main parse function produced by yacc/bison. 

- QGrammar.y
 - The yacc/bison input describing the grammar rules and actions. This file contains a starting point covers all of the required things and production rules for declaration statements. You will need to complete this file. 

- QTokens.h
 - This file lists defines for symbolic constants for the token types required by the grammar. You will need to extend this as more capabilities are added. 

- CodeGen.h/.c
 - The contains support functions for creating, manipulating and writing assembly code sequences. The implementation is complete.

- Semantics.h/.c
 - This will contain the implementation of the semantic actions used in compilation. It has stubs for the semantic actions used for variable declarations as well as some of the required data structures.

- Makefile
- This file has been updated to include rules for this portion of the project. 

You will need to create the following

- QScanner.l
 - The lex/flex input describing the tokens required by the parser. You can create this from previous versions. It should include the comment nesting capabilities contained in the previous versions.
 

## The Assignment

- Step 1, 20 pts
 - Implement the necessary semantic actions for variable declarations. Create a test program, q1.src to exercise this part. 

- Step 2, 20 pts
 - Add rules and semantic actions to compile simple expressions and assignment statements. Implement get() and put() functions for I/O of simple data types. Get() should be allowed in place of an identifier in expressions and put() should be considered a statement on its own. These are implemented in assembly with syscalls. Create a test program to exercise this part. 

- Step 3, 20 pts
 - Add rules and semantic actions for "if/then/else" and "while" loops. Create a test program to exercise this part. 

- Step 4, 20 pts
 - Add rules and semantic actions to allow string literals in put() statements. Create a test program to exercise this. 

## What To Do

- Do not fork this repository on Gitlab, instead
- On your development machine, in a location different than your assignment repository, clone this project. Your assignment repository will continue to accumulate all files for the project. 
- Copies the files from this repository to your assignment repository.
- Discard the clone of this repository.
- Implement the required capabilities. 
- When complete, "make clean" to remove object files and executables, use git to add and commit your changes and push the project back up to your repository. Rememger to create an issue in Gitlab with me as the assignee indicating that your submission is ready for grading. 