# 信息的表示和处理
## 1. The storage
most of the computer use 8 bits as the smallest addressasble unit of the memory.
For the c program language, you can use the gcc comand-line option to choose the c++ version
```gcc
gcc -std=c11 prog.c
gcc -std=c99 prog.c   
```

### 1.1 Hexadecimal Notation
A single byte consist of the 8 bits,range from the $00000000_2 \to 1111111_x$
 In the decimal, it is from the 0 to 255

### 1.2 Data size 

Nowadays most of the machine is 64 bits rather than the 32 bits, but you can still run in the 32bits mode.
```c
gcc -m32 prog.c 
```
Most machine support 3 types of the floating-point formats: single precision`float in c` and the double precision `double in c`

 ### 1.3 Addressing and Byte Ordering
 In some machines they store the data from the big to the small while some are contrary.
 Take the 0x01234567 for example. 
 In the Big endian 
 `01 23 45 67`
 In the small endian
 `67 45 23 01`
 You can use the code below to test your machine endian
 ```c
 #include <stdio.h>
typedef unsigned char *byte_pointer;
void show_byte(byte_pointer start,size_t len) {
    int i;
    for (int i = 0;i < len;i++)
        printf("%.2x",start[i]);
    printf("\n");
}
void show_int(int x) {
    show_byte((byte_pointer)&x, sizeof(int));
}
void show_float(float x) {
    show_byte((byte_pointer)&x,sizeof(float));
}
void show_pointer(void *x) {
    show_byte((byte_pointer)&x,sizeof(void *));
}
void show_long(long int x) {
    show_byte((byte_pointer)&x,sizeof(long int));
}
int main() {
    float a = 1;
    int b = 1;
    int *p = &b;
    show_int(b);
    show_pointer(p);
    show_float(a);
    long int c = 1;
    show_long(1);
}
 ```
 > Q: why use the unsigned char*
 A: Using a type of unsigned can avoid overflow.Using the char can make it point to one byte at a time
 Q: why use the %.2x
 A: Because every byte have 8 bits while the 16 only takes 4 bits, so we need two number to record it.


