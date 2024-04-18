#include <stdio.h>
#include "add.h"

// zig cc src/main.c src/add.c -o add.exe 
// zig cc src/*.c -o add.exe
int main(void) {

    int a = 21;
    int b = 21;
    int c = add(a, b);
    printf("%d + %d = %d\n", a, b, c);
    printf("%d + %d = %d\n", a, INCREMENT_BY, increment(a));
    printf("a++ = %d\n", increment(a));


    return 0;
}