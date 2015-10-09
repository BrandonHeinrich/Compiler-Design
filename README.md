# CS 442 - Compiler Construction
## Scanner Assignment Respository

This repository contains files to be added to your main project repository to include the Scanner portion of the project. The repository 

- ScannerDriver.c
 - This is the test driver for this portion of the project. The driver opens source and listing files and repeatedly requests the next token from the scanner. Depending on the token type different actions are taken. 
- Scanner.l
 - This is the starting point for the scanner definition. It contains the outline of the needed scanner rules. 
- Scanner.h
 - This exposes as an include file the functions and data provided by the lex/flex generated scanner. 
- Tokens.h
 - This is an include file containing defines for the various token types. 
- Makefile
 - The Makefile containing new rules and definitions for the scanner component. 

- ScanEx0.l
 - An example of a standalone scanner that recognizes simple token types. 
- ScanEx1.l
 - An example of a standalone scanner that on seeing an integer, evaluates and displays the factorial of the integer. 
- ScanEx2.l
 - An example of a standalone scanner that evaluates postfix arithmetic expressions. 

## The Assignment

- Part 1
 - Create a standalone scanner (call the file ScanExample.l) that recognizes camel-case identifiers (lower case sequence, single upper case letter, lower case sequence, single upper case letter, etc) and displays the token text in reverse order. All other input should be discarded. 
- Part 2
 - Scanner.l contains rules for the INIT, DUMP and Identifier tokens. Extend these rules to incorporate comments (both "/* ... */" comments and through to the end of line comments "// ...."). Include the code necessary to only return tokens when not inside a comment. Also include rules for integers,  floats and at least one symbol. You will need to add defines for these token types to Tokens.h.
 - ScannerDriver.c contains most of the required code. The cases for INIT and DUMP are supplied. INIT creates a symbol table and DUMP displays the contents of the table. You need to supply code for the IDENT_TOK case to add the token text to the symbol table with an appropriate attributes structure. The additional tokens you define do not require action cases. 

## What To Do

- Do not fork this repository on Gitlab, instead
- On your development machine, in a location different than your assignment repository, clone this project. Your assignment repository will continue to accumulate all files for the project. 
- Copies the files from this repository to your assignment repository.
- Discard the clone of this repository.
- Implement the required capabilities. 
- When complete, "make clean" to remove object files and executables, use git to add and commit your changes and push the project back up to your repository.


