#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "IOMngr.h"

// File Pointers
FILE *source;
FILE *listing;

// Position Holders
int line;
int column;

char buffer[MAXLINE];

int message_num;
int message_position[26];

char message[26][MAXLINE];

bool needUpdate;

bool OpenFiles(const char *aSourceName, const char *aListingName) {
	source = fopen(aSourceName, "r");

	if(aListingName == NULL) {
		listing = stdout;
	} else {
		listing = fopen(aListingName, "w");
	}

	line = 1;
	column = 0;
	message_num = 0;
	needUpdate = false;

	if(source != NULL && listing != NULL) {
		return true;
	} else {
		return false;
	}
}

void CloseFiles() {
	UpdateListingFile();
	fclose(source);
	if(listing != stdout) {
		fclose(listing);
	}
}

char GetSourceChar() {
	char next = fgetc(source);
	if(next == '\t') next = ' ';

	switch(next) {
		case EOF:
			break;
		case '\n':
			needUpdate = true;
			buffer[column] = next;
			column += 1;
			break;
		default:
			if(needUpdate) {
				UpdateListingFile();
			}
			buffer[column] = next;
			column += 1;
			break;
	}
	return next;
}

void PostMessage(int aColumn, const char *aMessage) {
	if(message_num > 0 && message_num < 27 && message_position[message_num-1] == aColumn) {
		strcat(message[message_num-1], "\n     | ");
		strcat(message[message_num-1], aMessage);
	} else if(message_num < 26) {
		message_position[message_num] = aColumn;
		strcpy(message[message_num], aMessage);
		message_num += 1;
	}
}

int GetCurrentLine() {
	return line;
}

int GetCurrentColumn() {
	return column;
}

void UpdateListingFile() {
	needUpdate = false;
	if(message_num > 0 || listing != stdout) {
		fprintf(listing, "%5d: ", line);
		int i;
		for(i=0; i<column; i+=1) {
			fputc(buffer[i], listing);
			if(buffer[i] == '\n') {
				break;
			}
		}
	}
	line += 1;
	column = 0;
	

	if(message_num > 0) {
		fprintf(listing, "      ");
		int i;
		int cur = 0;
		for(i=0; cur < message_num; i+=1) {
			if(i == message_position[cur]) {
				fputc('A' + cur, listing);
				cur += 1;
			} else {
				fputc(' ', listing);
			}
		}
		fputc('\n', listing);
		for(i=0; i<message_num; i+=1) {
			fprintf(listing, "    -%c %s\n", 'A'+i, message[i]);
		}
		message_num = 0;
		fputc('\n', listing);
	}
}
