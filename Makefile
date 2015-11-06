LOADLIBES = -ll

# Symbol Table Project
SymTab.o: SymTab.c SymTab.h

SymTabDriver: SymTabDriver.o SymTab.o

symtest: SymTabDriver
	./SymTabDriver

# IOMngr Project
IOMngr.o: IOMngr.c IOMngr.h

IOMngrDriver: IOMngrDriver.o IOMngr.o

iotest: IOMngrDriver
	./IOMngrDriver io/input/IOMngrSource io/output/IOMngrListing

# Scanner Project
ScannerDriver.o: ScannerDriver.c Scanner.h Tokens.h 

ScannerDriver: ScannerDriver.o Scanner.o SymTab.o IOMngr.o

scantest: ScannerDriver
	./ScannerDriver

# Recursive Descent Project
RecDescent.o: RecDescent.c Scanner.h RDTokens.h

RecDescent: RecDescent.o RDGrammar.o RDScanner.o RDSupport.o IOMngr.o SymTab.o

rdtest: RecDescent
	./RecDescent RDSource

IntRDScanner: RDScanner.l
	flex RDScanner.l
	gcc lex.yy.c -lfl
	./a.out
	
test: ParserScanner.l ParserGrammar.y
	flex ParserScanner.l
	yacc ParserGrammar.y
	gcc lex.yy.c y.tab.c IOMngr.c -lfl -s
	valgrind ./a.out < io/input/ParserScr1.src

Parse: Parse.c flex/ParserScanner.l yacc/ParserGrammar.y Grammar.h Scanner.h RDTokens.h IOMngr.o
	flex flex/ParserScanner.l
	yacc yacc/ParserGrammar.y
	mv lex.yy.c ParserScanner.c
	mv y.tab.c ParserGrammar.c
	gcc Parse.c ParserScanner.c ParserGrammar.c IOMngr.c -ll -ly
	mv a.out Parse

# Other
clean:
	rm *.o SymTabDriver IOMngrDriver ScannerDriver RecDescent
	rm *~
	
	
	
	
