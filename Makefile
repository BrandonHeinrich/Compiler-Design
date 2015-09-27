
SymTab.o: SymTab.c SymTab.h

SymTabDriver: SymTabDriver.o SymTab.o

symtest: SymTabDriver
	./SymTabDriver < SymData.txt

IOMngr.o: IOMngr.c IOMngr.h

IOMngrDriver: IOMngrDriver.o IOMngr.o

iotest: IOMngrDriver
	./IOMngrDriver IOMngrSource IOMngrListing

clean:
	rm *.o SymTabDriver IOMngrDriver
