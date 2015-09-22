
SymTab.o: SymTab.c SymTab.h macros.h

SymTabDriver: SymTabDriver.o SymTab.o

test: SymTabDriver
	./SymTabDriver < SymData.txt

clean:
	rm *.o SymTabDriver
