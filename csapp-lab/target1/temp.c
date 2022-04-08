#include <stdio.h>
#include <string.h>
int main() {
    char a[10];
    scanf("%s",a);
    for (int i = 0;i < strlen(a);i++) {
        printf("%x ",a[i]);
    }
}
