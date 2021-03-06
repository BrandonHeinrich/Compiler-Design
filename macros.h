#ifndef __MY__MACROS__
#define __MY__MACROS__

#include <strings.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef DEBUG_LEVEL

#define DEBUG(x) fprintf(stdout,x)
#define BEGIN(x) fprintf(stdout,"<Entering: ");fprintf(stdout,x);fprintf(stdout,">\n")
#define RETURN(name,place,value) fprintf(stdout,"<Returning from: ");fprintf(stdout,name);\
				 fprintf(stdout," at Location: ");fprintf(stdout,place);fprintf(stdout,">\n");return value

#endif
#ifndef DEBUG_LEVEL

#define DEBUG(x)
#define BEGIN(x)
#define RETURN(name,place,value) return value

#endif



#endif
