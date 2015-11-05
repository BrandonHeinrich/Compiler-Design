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
	./a.outq

# Other
clean:
	rm *.o SymTabDriver IOMngrDriver ScannerDriver RecDescent
	rm *~
	
testall: SymTabDriver IOMngrDriver ScannerDriver RecDescent
	./SymTabDriver
	./IOMngrDriver
	./ScannerDriver
	./RecDescent RDSource
	rm *.o SymTabDriver IOMngrDriver ScannerDriver RecDescent
	rm *~
	
	
	
