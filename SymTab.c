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

/* The Name/Attributes association structure used in the symbol tables
   linked list.
*/
struct SymEntry { char *name;
                  void *attributes;
                  struct SymEntry *next;
};

/* The symbol table structure proper. The hash table array Contents
   is dynamically allocated according to size
*/
struct SymTab { int size;
                struct SymEntry **contents;
};

/* CreateSymTab   create and return a pointer to a symbol table of
                  approximately Size many entries. If creation of
		  the symbol table fails, return NULL
   
   DestroySymTab  destroy all storage associated with a Symbol Table which 
                  is under the table's control. Any use of the table after
                  destruction automatically fails.
*/
struct SymTab *   CreateSymTab(int size) {
	// Create a Symbol Table
	struct SymTab table;

	// Populate Fields
	table.size = size;
	table.contents = malloc(sizeof(SymEntry)*size);

	// If allocation of memory for the pointer array
	// fails, then return nothing.
	if(table.contents == NULL) {
		return NULL;
	}

	// If a pointer in the array is NULL, there is no
	// entry at that point yet. If it is non-NULL, 
	// there is an entry. For creating an empty table,
	// It must be assured that all elements are NULL
	for(int i = 0; i < size; i += 1) {
		table.contents[i] = NULL;
	}

	// Return the address of the SymTab
	return &table;	
}

void              DestroySymTab(struct SymTab *aTable) {
	// Walk through array, and for each element, destroy the 
	// table entries associated with it.
	for(int i = 0; i < aTable->size; i += 1) {
		DestroySymEntry(aTable->contents[i]);
		// Set pointer to zero to prevent accidental use
		aTable.contents[i] = NULL;
	}
	
	// Finally, free the allocated memory
	free(aTable->contents);
	
	// Set contents to null to prevent accidental errors.
	aTable->contents = NULL

	// Set size to -1 to flag that table has been destroyed
	aTable->size = -1;
}

/* EnterName      enter a Name into a symbol table. Returns a 
                  boolean indicating whether an entry for Name was 
                  already listed in the table. Passes back an argument
                  containing an entry reference for the name.
   
   FindName       find a Name in a symbol table. Return an entry reference
                  or NULL depending on whether the Name was found.
*/
bool              EnterName(struct SymTab *aTable,
                            const char *name,
                            struct SymEntry **anEntry);
struct SymEntry * FindName(struct SymTab *aTable,
                           const char * name);

/* SetAttr        set the attribute pointer associated with an entry. 
   GetAttr        get the attribute pointer associated with an entry.
   GetName        get the name string associated with an entry.
*/   
void              SetAttr(struct SymEntry *anEntry,
                          void *attributes);
void       *      GetAttr(struct SymEntry *anEntry);
const char *      GetName(struct SymEntry *anEntry);

/* These two functions can be used to enumerate the contents of a table. 
   The enumeration order is arbitrary.
   
   FirstEntry     return the "first" entry in a symbol table or 
                  NULL if the table is empty. "First" does not
                  imply a particular order (e.g. alphabetical) 
                  it is simply the order found in the table.
   
   NextEntry      return the next entry after the supplied entry 
                  or NULL if no more entries.
*/
struct SymEntry *  FirstEntry(struct SymTab *aTable);
struct SymEntry *  NextEntry(struct SymTab *aTable,
                             struct SymEntry *anEntry);
        
        
/* 
*/

struct Stats { int minLen;
               int maxLen;
               int avgLen;
               int entryCnt;
};
struct Stats *     Statistics(struct SymTab *aTable);
