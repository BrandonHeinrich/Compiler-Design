# CS 442 - Compiler Construction
## Parser

This repository contains files to be addded to your main project repository to include the Parser capabilities. The repository contains

- Parse.c
 - This is the test driver for the assignment. This driver takes one argument, the base name of the source and listing files, and opens these files by appending ".src" and ".lst" to the base name. It then starts the main parse function produced by yacc/bison.

- Grammar.h
 - An include file exposing the yyparse() function generated by yacc/bison.

- ParserGrammar.y
 - The yacc/bison input describing the grammar rules and actions. A starting point for this file is supplied. You will need to complete it. 

- ParserScanner.l
 - The lex/flex input describing the tokens required by the parser. A empty file is supplied. You will complete this by using the RDScanner.l token definitions with the comment nesting capabilities implemented in the previous Scanner.l. 

- Makefile
 - This file has been updated to include rules for this portion of the project. 

In addiiton to these, this project will reuse the previous RDTokens.h and Scanner.h files. 

## The Assignment

- Step 1, 5 pts
 - Using yacc/bison implement a parser for the same grammar used in the recursive descent assignment (except for real literals). This will involve completing ParserGrammar.y and ParserScanner.l. Create two source files (using RDSource.src as a starting point) called ParserSrc1.src and ParseSrc2.src to use as test input. Include the corresponding listing files in the submission.

- Step 2, 15 pts
 - Using the same grammar as in Step 1, and using printf and PostMessage statements as semantic actions, convert expressions to postfix form. Create a third source file (ParserSrc3.src) to use as test input and include the corresponding listing file in the submission. 

## What To Do

- Do not fork this repository on Gitlab, instead
- On your development machine, in a location different than your assignment repository, clone this project. Your assignment repository will continue to accumulate all files for the project. 
- Copies the files from this repository to your assignment repository.
- Discard the clone of this repository.
- Implement the required capabilities. 
- When complete, "make clean" to remove object files and executables, use git to add and commit your changes and push the project back up to your repository. Rememger to create an issue in Gitlab with me as the assignee indicating that your submission is ready for grading. 
