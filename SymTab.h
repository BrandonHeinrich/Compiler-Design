/* SymTab.h

  This file defines the interface to a simple symbol table. 
  For the purposes of this module a symbol table is abstractly    
  viewed as a collection of entries each associating a name
  with a single attribute which is taken to be a (void *). 
  This allows the user to associate a name with an arbitrary
  structure of attribute information which the user creates
  and maintains. There is no predetermined limit on the number 
  of entries a symbol table can hold. Nor is there a predetermined 
  limit on the size of a name. At creation an estimated size is 
  provided. This is used by the implementation as an advisory for 
  initial storage allocation. 
  
  The following functionality is provided
  - symbol table creation and destruction
  - getting and setting an entry's attribute pointers
  - getting an entry's name string
  - enumerating the contents of the table
*/

#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

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

/* CreateSymTab   create and return a reference to a symbol table of
                  approximately Size many entries.
   
   DestroySymTab  destroy all storage associated with a Symbol Table which 
                  is under the table's control.
*/
struct SymTab *   CreateSymTab(int size);
void              DestroySymTab(struct SymTab *aTable);

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
