#include <stdio.h>

extern int fn(int a, int b);

int main() {
    int a = 4;
    int b = 5;
    
    printf("Calling assembly function fn with x0=%d and x1=%d results in %d\n", a, b, fn(a,b));
    return(0);
}
