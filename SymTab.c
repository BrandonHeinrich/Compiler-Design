#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

//define DEBUG_LEVEL 0

#include "SymTab.h"
#include "macros.h"



struct SymTab * CreateSymTab(int size) {
	BEGIN("CreateSymTab");
	struct SymTab *aTable = malloc(sizeof(struct SymTab));
	aTable->size = size;
	aTable->contents = malloc(size*sizeof(struct SymEntry*));
	int i;
	for(i=0; i<aTable->size; i+=1) aTable->contents[i] = NULL;
	RETURN("CreateSymTab", "1", aTable);
}
void DestroySymTab(struct SymTab *aTable) {
	BEGIN("DestroySymTab");
	int i;
	for(i=0; i<aTable->size; i+=1) {
		struct SymEntry *head = aTable->contents[i];
		while(head != NULL) {
			struct SymEntry *next = head->next;
			free(head->next);
			free(head);
			head = next;
		}
	}
	free(aTable->contents);
	free(aTable);
}
int Hash(const char *name) {
	BEGIN("Hash");
	int hash = strlen(name);
	RETURN("Hash", "1", hash);
}
bool EnterName(struct SymTab *aTable, const char *name, struct SymEntry **anEntry) {
	BEGIN("EnterName");
	if(FindName(aTable, name) != NULL) {
		*anEntry = FindName(aTable, name);
		RETURN("EnterName", "1", true);
	}
	DEBUG("<ALLOCATE ENTRY>\n");
	struct SymEntry *head = malloc(sizeof(struct SymEntry));
	DEBUG("<COPY NAME>\n");
	head->name = malloc(16*sizeof(char));
	//printf("Before: %15s \n",name);
	//printf("Before: %15s \n",head->name);
	strcpy(head->name, name);
	//printf("After: %15s \n",name);
	//printf("After: %15s \n",head->name);
	DEBUG("<SET ATTRIBUTES>\n");
	head->attributes = NULL;
	DEBUG("<PREPEND TO LIST>\n");
	head->next = aTable->contents[Hash(name) % aTable->size];
	DEBUG("<ADD TO TABLE>\n");
	aTable->contents[Hash(name) % aTable->size] = head;
	*anEntry = head;
	RETURN("EnterName", "2", false);
}
struct SymEntry * FindName(struct SymTab *aTable, const char *name){
	BEGIN("FindName");
	int x = Hash(name) % aTable->size;
	DEBUG("<CALC_SIZE>\n");
	struct SymEntry *head = aTable->contents[x];
	while(head != NULL) {
		DEBUG("<LOOPING>");
		if(strcmp(name, head->name) == 0) return head;
		else head = head->next;
	}
	RETURN("FindName", "1", NULL);
}  
void SetAttr(struct SymEntry *anEntry, void *attributes) {
	BEGIN("SetAttr");
	anEntry->attributes = attributes;
}
void * GetAttr(struct SymEntry *anEntry) {
	BEGIN("GetAttr");
	RETURN("GetAttr", "1", anEntry->attributes);
}
const char * GetName(struct SymEntry *anEntry) {
	BEGIN("GetName");
	RETURN("GetName", "1", anEntry->name);
}
struct SymEntry * FirstEntry(struct SymTab *aTable) {
	BEGIN("FirstEntry");
	int i;
	for(i=0; i<aTable->size; i+=1) {
		if(aTable->contents[i] != NULL) {
			return aTable->contents[i];
		}
	}
	return NULL;
}
struct SymEntry * NextEntry(struct SymTab *aTable, struct SymEntry *anEntry) {
	BEGIN("NextEntry");
	struct SymEntry *result;
	result = NULL;
	if(anEntry->next == NULL) {
		int i = Hash(anEntry->name)%aTable->size;
		i += 1;

		if(i == aTable->size) return NULL;
		
		for(; i < aTable->size; i+=1) {
			//printf("Checking row %d\n",i);
			if(aTable->contents[i] != NULL) {
				return aTable->contents[i];
			}
		}
	} else {
		return anEntry->next;
	}
	return result;
}
struct Stats * Statistics(struct SymTab *aTable) {
	BEGIN("Statistics");
	struct Stats *stats = malloc(sizeof(struct Stats));

	stats->minLen = 0;
	stats->maxLen = 0;
	stats->entryCnt = 0;

	int l;
	int i;
	struct SymEntry *h;
	for(i=0;i<aTable->size;i+=1) {
		l=0;
		h=aTable->contents[i];
		while(h != NULL) {
			l += 1;
			stats->entryCnt += 1;
			h=h->next;
		}
		stats->minLen = (l<stats->minLen?l:stats->minLen);
		stats->maxLen = (l>stats->maxLen?l:stats->maxLen);
	}
	
	

	stats->avgLen = stats->entryCnt / aTable->size;
	RETURN("Statistics", "1", stats);
}
