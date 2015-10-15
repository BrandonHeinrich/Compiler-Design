# CS 442 - Compiler Construction
## RecDescent

This repository contains files to be added to your main project repository to include the IOMngr capabilities. The repository contains

- RecDescent.c
 - This is the test driver for the assignment. This driver takes one argument, the base name of the source and listing files, and opens the source and listing by appending ".src" and ".lst" to the base name. It then starts the recursive descent process. 

- RDGrammar.h and RDGrammar.c
 - These contain the implementations of the recursive descent functions. 

- RDSupport.h and RDSupport.c
 - These contain the implementations of support functions in particular matching an expected token.

- RDScanner.l
 - This specifies the token types used in this project. It will reuse the Scanner.h file from the previous assignment to expose the functions and data created by Flex in compiling this specification. 

- RDTokens.h
 - This provides symbolic constants for the required token types. 

## The Assignment

- Complete RDScanner.l to specify regular expressions and actions for the required token types. You can start with your file from the Scanner project and modify it to include the tokens required for this project. 

- Complete RDGrammar.c to provide the implementation of the required recursive descent functions. If a function corresponds to a single production rule then it will simply be a sequence of token tests. If a function corresponds to multiple productions then you will need to determine the select sets for the productions and implement a switch to choose the correct production. Include the select sets in the comments.

- Extra Credit: Devise a way to partially recover from a parse error so that parsing can continue after an error is encountered. 

## What To Do

- Do not fork this repository on Gitlab, instead
- On your development machine, in a location different than your assignment repository, clone this project. Your assignment repository will continue to accumulate all files for the project. 
- Copies the files from this repository to your assignment repository.
- Discard the clone of this repository.
- Implement the required capabilities. 
- When complete, "make clean" to remove object files and executables, use git to add and commit your changes and push the project back up to your repository.
