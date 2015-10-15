/* Recursive Descent Support Functions */
#ifndef RDSUPPORT_H
#define RDSUPPORT_H

#define RECURSION_DEPTH 30

/* Global Variable */
extern int CurToken;

void Enter(char *Name);
void Leave(char *Name);
void WriteCallStack();

void ParseError(char *Message);
bool Match(int ExpectedToken);

#endif
