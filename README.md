# CS 442 - Compiler Construction
## SymTab Assignment Respository

This repository initially contains the SymTab Assignment files: 

- SymTabDriver.c 
 - The main test driver for the assignment. This driver creates a symbol table, reads names and values from stdin, enters the names into the table, displays the table contents, creates a second table, copies the names from the first table into the second and finally displays the contents of the second table. 
- SymTab.h 
 - The include file defining the required structures and functions for the implementation. 
- SymData.txt 
 - A file of test data. This provides a minimal test. Your submission will be tested with a different data file. 
- Makefile 
 - The Makefile containing the dependency rules as well as "clean" and "test" targets.

You will need to create a SymTab.c file and implement the required functions. The project can be tested with "SymTabDriver < SymData.txt" or "make test" is a shorthand for this. When complete, "make clean" to remove object files and executables, use git to add and commit your changes and push the project back up to your repository.

