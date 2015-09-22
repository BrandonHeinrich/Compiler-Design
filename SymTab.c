/* SymTab.c
  
  This file implements the interface to a simple symbol table.
  For the purposes of this module a symbol table is abstractly    
  viewed as a collection of entries each associating a name
  with a single attribute which is taken to be a (void *). 

  For more information about the specifactions and use of
  the symbol table, please see the header file, SymTab.h
  
  The following functionality is provided
  - symbol table creation and destruction
  - getting and setting an entry's attribute pointers
  - getting an entry's name string
  - enumerating the contents of the table
*/
#include "SymTab.h"

#include <strings.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* The Name/Attributes association structure used in the symbol tables
   linked list.

struct SymEntry {
	char *name;
    void *attributes;
	struct SymEntry *next;
}; */

/* The symbol table structure proper. The hash table array Contents
   is dynamically allocated according to size

struct SymTab {
	int size;
	struct SymEntry **contents;
}; */

/* CreateSymTab   create and return a pointer to a symbol table of
                  approximately Size many entries. If creation of
		  the symbol table fails, return NULL

   DestroyHelper  destroys a SymEntry, and frees all the memory associated
		  with it. If there is a SymEntry pointed to by this Entry,
		  it is also destroyed.
   
   DestroySymTab  destroy all storage associated with a Symbol Table which 
                  is under the table's control. Any use of the table after
                  destruction automatically fails.
*/
struct SymTab* CreateSymTab(int size) {
	fprintf(stdout, "Entering: CreateSymTab\n");
	// Allocate space for the Symbol Table Structure
	// And create a pointer to that location
	struct SymTab *table = malloc(sizeof(struct SymEntry));

	// Save size of the table.
	(*table).size = size;

	// Allocate space for an array of SymEntries
	// That is size entries long. Set contents pointer in
	// The symbol table to the location of the first
	// element in the array
	(*table).contents = malloc(sizeof(struct SymEntry*) * size);

	// If a pointer in the array is NULL, there is no
	// entry at that point yet. If it is non-NULL, 
	// there is an entry. For creating an empty table,
	// It must be assured that all elements are NULL
	int i;
	for(i = 0; i < size; i += 1) {
		(*table).contents[i] = NULL;
	}

	// Return the pointer to the SymTab
	fprintf(stdout, "Leaving: CreateSymTab\n");
	return table;	
}

void DestroySymTab(struct SymTab *aTable) {
	fprintf(stdout, "Entering: DestroySymTab\n");
	// Loop through all elements of the Symbol table array.
	// If the entry is null, there is nothing to do
	// so move on to the next one. If it is non-null,
	// Then there is the head of a linked list of SymEnties.
	// Release memory for all symentries, then set the value
	// in the array to null to prevent accidental access.
	int i;
	for(i = 0; i < (*aTable).size; i += 1) {
		// Check if pointer is non-null. If it is null
		// There is nothing to do in this iteration of the loop.
		if((*aTable).contents[i] != NULL) {
			// There is a linked list in this entry of the array
			// Grab the head of the list for easy access.
			struct SymEntry *head = (*aTable).contents[i];
			
			// the head pointer will always point to the first
			// element in the linked list that hasnt been freed
			// if the head is null, we are done
			while(head != NULL) {
				// Save a reference to the next element
				// So it can still be accessed after
				// the head has been freed.
				struct SymEntry *next = (*head).next;

				// Free memory allocated for the current symentry
				free(head);

				// The next element is now the head.
				head = next;
			}




			// All of the memory associated with the linked
			// list in the array has been freed. Now set
			// The array entry to null to signify it is empty
			(*aTable).contents[i] = NULL;
		}
	}
	
	// All of the symentries are freed, so now free the memory used
	// for the array.
	free((*aTable).contents);

	// All allocated memory in the symtable has been freed.
	// Finall, free the memory for the symtab structure
	free(aTable);
	fprintf(stdout, "Leaving: DestroySymTab\n");
}

/* HashName       calculate the hash value of a name

   EnterName      enter a Name into a symbol table. Returns a 
                  boolean indicating whether an entry for Name was 
                  already listed in the table. Passes back an argument
                  containing an entry reference for the name.
   
   FindName       find a Name in a symbol table. Return an entry reference
                  or NULL depending on whether the Name was found.
*/
int HashName(const char* name) {
	fprintf(stdout, "Calling: HashName\n");
	// Just return 0 for now as it will simplify testing
	return 0;
}

bool EnterName(struct SymTab *aTable, const char *name, struct SymEntry **anEntry) {
	fprintf(stdout, "Entering: EnterName\n");
	
	
	// First, find out if the name is in the table
	fprintf(stdout, "(A)");
	if(anEntry==NULL)fprintf(stdout, "(NULL POINTER)");
	(*anEntry) = FindName(aTable, name);

	// If the name is in the table, the pointer will
	// be non-null, so return true.
	fprintf(stdout, "(B)");
	if((*anEntry) != NULL) {
		fprintf(stdout, "(B.A)");
		fprintf(stdout, "Leaving: EnterName\n");
		return true;
	}

	// Name is not in the table, so we need to add it
	// Allocate space for a new SymEntry
	fprintf(stdout, "(C)");
	struct SymEntry *newEntry = malloc(sizeof(struct SymEntry *));

	// We need to find out what slot the entry would be
	// the symbol table. Do this by hashing the name
	// then taking the remainder when dividing it by 
	// the table size
	fprintf(stdout, "(D)");
	fprintf(stdout, "(D.A)");
	int hash = 0;//HashName(NULL);
	fprintf(stdout, "(D.B)");
	if(aTable) fprintf(stdout, "(D.B.Y)");
	else fprintf(stdout, "(D.B.N)");
	int s = (*aTable).size;
	fprintf(stdout, "(D.C)");
	int slot = hash%s;

	// for testing, assume slot is 0;
	fprintf(stdout, "(E)");
	slot = 0;

	// We need to copy the name string into the name
	// space of the new symentry
	fprintf(stdout, "(F)");
	strcpy((*newEntry).name, name);

	// We will be putting the new entry at the front of
	// the list. This means that the next element
	// will be the element currently at the front of
	// the list
	fprintf(stdout, "(G)");
	(*newEntry).next = (*aTable).contents[slot];

	// Now, we have to put the new entry in the table
	// It will become the new head of the list
	fprintf(stdout, "(H)");
	(*aTable).contents[slot] = newEntry;

	// As we can only return one value, we need to
	// return the pointer to the new entry another
	// way. We were given a memory location by the
	// callee. We will store a pointer to the new enty
	// there.
	fprintf(stdout, "(I)");
	(*anEntry) = newEntry;
	
	// entry was not in the table, so we need to return false
	fprintf(stdout, "(J)");
	fprintf(stdout, "Leaving: EnterName\n");
	return false;
}
struct SymEntry *FindName(struct SymTab* aTable, const char* name) {
	fprintf(stdout, "Entering: FindName\n");
	// We need to find out what slot the entry would be
	// the symbol table. Do this by hashing the name
	// then taking the remainder when dividing it by 
	// the table size
	int slot = HashName(name) % (*aTable).size;

	// for testing, assume slot is 0;
	slot = 0;
	
	// Find head of the list
	struct SymEntry (*head) = (*aTable).contents[slot];

	// Walk list looking for name
	while(head != NULL) {
		// If we found the name, return its entry
		if(strcmp(name, (*head).name) == 0) {
			fprintf(stdout, "Leaving: FindName\n");
			return head;
		}

		// Move to next element in the list
		head = (*head).next;
	}	
	
	// Reached end of list with out finding
	// name. returning null
	fprintf(stdout, "Leaving: FindName\n");
	return NULL;
}

/* SetAttr        set the attribute pointer associated with an entry. 
   GetAttr        get the attribute pointer associated with an entry.
   GetName        get the name string associated with an entry.
*/   
void SetAttr(struct SymEntry *anEntry, void* attributes) { 
	fprintf(stdout, "Calling: SetAttr\n");
	(*anEntry).attributes = attributes;
}
void* GetAttr(struct SymEntry *anEntry) {
	fprintf(stdout, "Calling: GetAttr\n");
	return (*anEntry).attributes;
}
const char* GetName(struct SymEntry *anEntry) {
	fprintf(stdout, "Calling: GetName\n");
	return (*anEntry).name;
}

/* These two functions can be used to enumerate the contents of a table. 
   The enumeration order is arbitrary.
   
   FirstEntry     return the "first" entry in a symbol table or 
                  NULL if the table is empty. "First" does not
                  imply a particular order (e.g. alphabetical) 
                  it is simply the order found in the table.
   
   NextEntry      return the next entry after the supplied entry 
                  or NULL if no more entries.
*/
struct SymEntry* FirstEntry(struct SymTab* aTable) {
	fprintf(stdout, "Entering: FirstEntry\n");
	int i;
	for(i = 0; i<aTable->size; i += 1) {
		if(aTable->contents[i] != NULL) {
			fprintf(stdout, "Leaving: FirstEntry\n");
			return aTable->contents[i];
		}
	}
	fprintf(stdout, "Leaving: FirstEntry\n");
	return NULL;
}
struct SymEntry* NextEntry(struct SymTab* aTable,
                           struct SymEntry* anEntry) {
	fprintf(stdout, "Entering: NextEntry\n");
	if(anEntry->next == NULL) {
		int nextRow = HashName(anEntry->name) % aTable->size;
		int i;
		for(i = nextRow; i<aTable->size; i += 1) {
			if(aTable->contents[i] != NULL) {
				fprintf(stdout, "Leaving: NextEntry\n");
				return aTable->contents[i];
			}
		}
	}
	fprintf(stdout, "Leaving: NextEntry\n");
	return anEntry->next;
}
        
        
/* 
struct Stats {
	int minLen;
	int maxLen;
	int avgLen;
	int entryCnt;
};*/

struct Stats* Statistics(struct SymTab* aTable) {
	fprintf(stdout, "Entering: Statistics\n");
	// Create stats structure
	struct Stats* stats = malloc(sizeof(struct Stats));

	// Zero fields in stats
	stats->minLen = 0;
	stats->maxLen = 0;
	stats->avgLen = 0;
	stats->entryCnt = 0;

	
	struct SymEntry* next = FirstEntry(aTable);
	while(next != NULL) {
		stats->entryCnt += 1;
		next = NextEntry(aTable, next);
	}

	fprintf(stdout, "Leaving: Statistics\n");
	return stats;
}
















