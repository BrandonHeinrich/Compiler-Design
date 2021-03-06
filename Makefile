LOADLIBES = -ll -ly
CFLAGS = -g 

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
	bison yacc/ParserGrammar.y
	flex flex/ParserScanner.l
	mv lex.yy.c ParserScanner.c
	mv ParserGrammar.tab.c ParserGrammar.h
	gcc Parse.c ParserScanner.c IOMngr.o -ll -ly
	mv a.out Parse
	
# Semantics
Q.o: 	Q.c Grammar.h Scanner.l IOMngr.h 
Q:	Q.o SymTab.o IOMngr.o QScanner.o QGrammar.o Semantics.o CodeGen.o

CodeGen.o: CodeGen.c CodeGen.h

Semantics.o: Semantics.c Semantics.h

Optimize.o: Optimize.c Optimize.h


MyQCompiler: QCompile.c flex/QScanner.l yacc/QGrammar.y IOMngr.o SymTab.o CodeGen.o Semantics.o Optimize.o
	bison yacc/QGrammar.y
	lex flex/QScanner.l
	mv lex.yy.c QScanner.c
	mv QGrammar.tab.c QGrammar.h
	gcc QCompile.c QScanner.c IOMngr.o SymTab.o CodeGen.o Semantics.o Optimize.o -ll -ly
	mv a.out QCompile

# Other
clean:
	rm *.o SymTabDriver Parse IOMngrDriver ScannerDriver RecDescent ParserGrammar.h ParserScanner.c
	clear
	
	
q1: QCompile.c flex/QScanner.l yacc/QGrammar.y IOMngr.o SymTab.o CodeGen.o Semantics.o
	make MyQCompiler
	./QCompile q1
	java -jar mars.jar nc io/output/q1.asm
	
q2: QCompile.c flex/QScanner.l yacc/QGrammar.y IOMngr.o SymTab.o CodeGen.o Semantics.o
	make MyQCompiler
	./QCompile q2
	java -jar mars.jar nc io/output/q2.asm

q3: QCompile.c flex/QScanner.l yacc/QGrammar.y IOMngr.o SymTab.o CodeGen.o Semantics.o
	make MyQCompiler
	./QCompile q3
	java -jar mars.jar nc io/output/q3.asm
	
q4: QCompile.c flex/QScanner.l yacc/QGrammar.y IOMngr.o SymTab.o CodeGen.o Semantics.o
	make MyQCompiler
	./QCompile q4
	java -jar mars.jar nc io/output/q4.asm
	
q5: QCompile.c flex/QScanner.l yacc/QGrammar.y IOMngr.o SymTab.o CodeGen.o Semantics.o
	make MyQCompiler
	./QCompile q5
	java -jar mars.jar nc io/output/q5.asm
	
q6: QCompile.c flex/QScanner.l yacc/QGrammar.y IOMngr.o SymTab.o CodeGen.o Semantics.o
	make MyQCompiler
	./QCompile q6
	java -jar mars.jar nc io/output/q6.asm
	
	
