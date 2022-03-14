section .data
    x dw 1
    y dw 2
section .text
global _start
_start:
mov ax,-1 
mov ebx,65536 
sub ebx,eax
mov ebx,eax
