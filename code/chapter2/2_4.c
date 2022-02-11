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
    // float a = 64;
    // int b = 64;
    // int *p = &b;
    // show_int(b);
    // show_pointer(p);
    // show_float(a);
    // long int c = 5;
    // show_long(c);
    int a = 0x12345678;
byte_pointer ap = (byte_pointer) &a;
show_byte(ap, 1); /* A. */
show_byte(ap, 2); /* B. */
show_byte(ap, 3); /* C. */
}