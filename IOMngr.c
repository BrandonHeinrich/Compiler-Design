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

	if(source != NULL && listing != NULL) {
		return true;
	} else {
		return false;
	}
}

void CloseFiles() {
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
			buffer[column] = next;
			column += 1;
			if(message_num > 0 || listing != stdout) {
				fprintf(listing, "%5d: ", line);
				int i;
				for(i=0; i<column; i+=1) {
					fputc(buffer[i], listing);
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
			
			break;
		default:
			buffer[column] = next;
			column += 1;
			break;
	}
	return next;
}

void PostMessage(int aColumn, const char *aMessage) {
	if(message_num < 26) {
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
