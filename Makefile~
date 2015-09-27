
SymTab.o: SymTab.c SymTab.h

SymTabDriver: SymTabDriver.o SymTab.o

test: SymTabDriver
	./SymTabDriver < SymData.txt

clean:
	rm *.o SymTabDriver
