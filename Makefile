LOADLIBES = -lfl

SymTab.o: SymTab.c SymTab.h

SymTabDriver: SymTabDriver.o SymTab.o

symtest: SymTabDriver
	./SymTabDriver < SymData.txt

IOMngr.o: IOMngr.c IOMngr.h

IOMngrDriver: IOMngrDriver.o IOMngr.o

iotest: IOMngrDriver
	./IOMngrDriver IOMngrSource IOMngrListing

ScannerDriver.o: ScannerDriver.c Scanner.h Tokens.h 

ScannerDriver: ScannerDriver.o Scanner.o SymTab.o IOMngr.o

scantest: ScannerDriver
	./ScannerDriver

ScanEx0: ScanEx0.l
	flex ScanEx0.l
	gcc lex.yy.c -lfl
	./a.out

ScanEx1: ScanEx1.l
	flex ScanEx1.l
	gcc lex.yy.c -lfl
	./a.out

ScanEx2: ScanEx2.l
	flex ScanEx2.l
	gcc lex.yy.c -lfl
	./a.out

ScanExample: ScanExample.l
	flex ScanExample.l
	gcc lex.yy.c -lfl
	./a.out

Interactive: Scanner.l
	flex Scanner.l
	gcc lex.yy.c -lfl
	./a.out

clean:
	rm *.o SymTabDriver IOMngrDriver ScannerDriver ScanEx0 ScanEx1 ScanEx2

