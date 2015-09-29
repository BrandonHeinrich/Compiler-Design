/* IOMngr.h
 
   Implements a simple interface for reading characters from
   the source file while producing a listing file. Functionality
   includes
 
   - opening source and listing files by name
   - closing source and listing files
   - getting a single character from the source file
   - post message to be included after a source line
   - get current line number
   - get current column number
   
   - OpenFiles opens the two files given by name. aSourceName is required
   but aListingName may be NULL. If aListingName is NULL output will be
   directed to stdout (the system output stream). If the opens are
   successful this function returns true, otherwise it returns false. 
   
   - CloseFiles closes the two files.
   
   - GetSourceChar returns the next character in the source file. This
   function must also arrange for source file lines to be echoed to the 
   listing file with a prepended line number. If aListingName was not null
   then all source lines are written to the listing. If aListingName was null
   then only lines that have posted messages are written to the listing. As a
   consequence, source lines must be read in their entirety and buffered. It is
   only when the characters of a line have been exhausted, and a new line must 
   be read, that the line is considered for printing to the listing file.
   Any tab characters ('\t')found in the input buffer are replaced by a 
   single ' '. The EOF character is returned if the source file is at the end 
   of file.
   
   - PostMessage registers a message to be associated with the current line
   and indicated by a marker in the indicated column. The letters 'A' ... 'Z' 
   are used as the markers, consequently, a maximum of 26 message lines are
   allowed for each source line. Calls to PostMessage beyond this limit are
   siliently ignored.
   
   - GetCurrentLine returns the current line number in the source file.
   
   - GetCurrentColumn returns the column number of the most recently
   returned character.

   Note: Error indicator and message lines must be correctly interspersed 
   with the echoed source file lines. This requires that source file lines 
   be read and buffered in their entirety prior to returning any characters
   from the line. The source lines are then echoed to the listing file. 
   If the listing file is null then only lines which are followed by error
   messages should be echoed.  
   
*/

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
                        
#define MAXLINE 1024
           
bool OpenFiles(const char * aSourceName,
               const char * aListingName);
void CloseFiles(); 

char GetSourceChar();

void PostMessage(int aColumn, const char * aMessage);

int GetCurrentLine();
int GetCurrentColumn();
