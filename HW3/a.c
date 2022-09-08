#include <stdio.h>
#include <stdlib.h> 
int main()
{
	char szNumbers[] = " 01995";
    char * pEnd;
    long int li1;
    li1 = strtol (szNumbers,&pEnd,10);
    printf ("%ld", li1);
 } 
