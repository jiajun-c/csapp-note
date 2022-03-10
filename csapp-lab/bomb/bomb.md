# CSAPP - bomblab
[TOC]
## 0. pre
[the link](http://www.csapp.cs.cmu.edu/3e/labs.html)
You can go to this website to download the ==self-study handout==
In the folder, you can see three file, bomb, bomb.c README.md , the extra files are my works.
```c
── ans.txt
├── bomb
├── bomb.c
├── bomb.md
├── out.txt
└── README

0 directories, 6 files
```
在本次的实验中，你还需要一些前置知识，比如
- [gdb debug](https://jiajun-c.github.io/2022/03/02/gdb/)
- [objump]()
## 1. 概述
在该lab中，你需要去拆解六个“炸弹”，你将通过反汇编去找寻这六个炸弹的线索
> A tip: 在原来的程序中一定存在着比较的语句

## 2. Start defuse
### 2.1 bomb one
首先我们使用gdb对程序进行调试，在phase_1的地方设置断点， 进入断点之后我们开始反汇编，在gdb窗口中使用`disas`对我们的section进行反汇编，得到的结果是
```shell
(gdb) disas
Dump of assembler code for function phase_1:
=> 0x0000000000400ee0 <+0>:	sub    $0x8,%rsp
   0x0000000000400ee4 <+4>:	mov    $0x402400,%esi
   0x0000000000400ee9 <+9>:	callq  0x401338 <strings_not_equal>
   0x0000000000400eee <+14>:	test   %eax,%eax
   0x0000000000400ef0 <+16>:	je     0x400ef7 <phase_1+23>
   0x0000000000400ef2 <+18>:	callq  0x40143a <explode_bomb>
   0x0000000000400ef7 <+23>:	add    $0x8,%rsp
   0x0000000000400efb <+27>:	retq
End of assembler dump.

```
You can see there is a <strings_not_equal>, if the string you input is not equal to the target one, the bomb wil bome.
We can guess that the string is storaged in the $0x402400, check the string storaged in the 0x402400, you can get the ans.
```shell
(gdb) x/s 0x402400
0x402400:	"Border relations with Canada have never been better."
```
### 2.2 bomb two
同样在phase_2处打下断点，然后进行调试
```shell
Breakpoint 1, 0x0000000000400efc in phase_2 ()
(gdb) disas
Dump of assembler code for function phase_2:
=> 0x0000000000400efc <+0>:	push   %rbp
   0x0000000000400efd <+1>:	push   %rbx
   0x0000000000400efe <+2>:	sub    $0x28,%rsp
   0x0000000000400f02 <+6>:	mov    %rsp,%rsi
   0x0000000000400f05 <+9>:	callq  0x40145c <read_six_numbers>
   0x0000000000400f0a <+14>:	cmpl   $0x1,(%rsp)
   0x0000000000400f0e <+18>:	je     0x400f30 <phase_2+52>
   0x0000000000400f10 <+20>:	callq  0x40143a <explode_bomb>
   0x0000000000400f15 <+25>:	jmp    0x400f30 <phase_2+52>
   0x0000000000400f17 <+27>:	mov    -0x4(%rbx),%eax
   0x0000000000400f1a <+30>:	add    %eax,%eax
   0x0000000000400f1c <+32>:	cmp    %eax,(%rbx)
   0x0000000000400f1e <+34>:	je     0x400f25 <phase_2+41>
   0x0000000000400f20 <+36>:	callq  0x40143a <explode_bomb>
   0x0000000000400f25 <+41>:	add    $0x4,%rbx
   0x0000000000400f29 <+45>:	cmp    %rbp,%rbx
   0x0000000000400f2c <+48>:	jne    0x400f17 <phase_2+27>
   0x0000000000400f2e <+50>:	jmp    0x400f3c <phase_2+64>
   0x0000000000400f30 <+52>:	lea    0x4(%rsp),%rbx
   0x0000000000400f35 <+57>:	lea    0x18(%rsp),%rbp
   0x0000000000400f3a <+62>:	jmp    0x400f17 <phase_2+27>
   0x0000000000400f3c <+64>:	add    $0x28,%rsp
   0x0000000000400f40 <+68>:	pop    %rbx
   0x0000000000400f41 <+69>:	pop    %rbp
   0x0000000000400f42 <+70>:	retq
End of assembler dump.
```
看到上面的`<read_six_numbers>`我们可以知道这次是让我们去输入六个数字
Then we can see `cmpl   $0x1,(%rsp)`, so the first number is 1, otherwise will trigger the bomb.
In the next statement, we jump to the `phase_2 + 52`,in which the second number will copy to the rbx.
Then will get into this loop
```shell
0x0000000000400f17 <+27>:	mov    -0x4(%rbx),%eax
0x0000000000400f1a <+30>:	add    %eax,%eax
0x0000000000400f1c <+32>:	cmp    %eax,(%rbx)
0x0000000000400f1e <+34>:	je     0x400f25 <phase_2+41>
0x0000000000400f20 <+36>:	callq  0x40143a <explode_bomb>
0x0000000000400f25 <+41>:	add    $0x4,%rbx
0x0000000000400f29 <+45>:	cmp    %rbp,%rbx
```
It will end until there are no number in the rbx, everytime the number will be doubled.
So the numbers are `1 2 4 8 16 32`

### 2.3 bomb three
Check the disassemle fisrt.
```shell
(gdb) disas
Dump of assembler code for function phase_3:
=> 0x0000000000400f43 <+0>:	sub    $0x18,%rsp
   0x0000000000400f47 <+4>:	lea    0xc(%rsp),%rcx
   0x0000000000400f4c <+9>:	lea    0x8(%rsp),%rdx
   0x0000000000400f51 <+14>:	mov    $0x4025cf,%esi
   0x0000000000400f56 <+19>:	mov    $0x0,%eax
   0x0000000000400f5b <+24>:	callq  0x400bf0 <__isoc99_sscanf@plt>
   0x0000000000400f60 <+29>:	cmp    $0x1,%eax
   0x0000000000400f63 <+32>:	jg     0x400f6a <phase_3+39>
   0x0000000000400f65 <+34>:	callq  0x40143a <explode_bomb>
   0x0000000000400f6a <+39>:	cmpl   $0x7,0x8(%rsp)
   0x0000000000400f6f <+44>:	ja     0x400fad <phase_3+106>
   0x0000000000400f71 <+46>:	mov    0x8(%rsp),%eax

   0x0000000000400f75 <+50>:	jmpq   *0x402470(,%rax,8)
   0x0000000000400f7c <+57>:	mov    $0xcf,%eax
   0x0000000000400f81 <+62>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400f83 <+64>:	mov    $0x2c3,%eax
   0x0000000000400f88 <+69>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400f8a <+71>:	mov    $0x100,%eax
   0x0000000000400f8f <+76>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400f91 <+78>:	mov    $0x185,%eax
   0x0000000000400f96 <+83>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400f98 <+85>:	mov    $0xce,%eax
   0x0000000000400f9d <+90>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400f9f <+92>:	mov    $0x2aa,%eax
   0x0000000000400fa4 <+97>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400fa6 <+99>:	mov    $0x147,%eax
   0x0000000000400fab <+104>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400fad <+106>:	callq  0x40143a <explode_bomb>
   0x0000000000400fb2 <+111>:	mov    $0x0,%eax
   0x0000000000400fb7 <+116>:	jmp    0x400fbe <phase_3+123>
   0x0000000000400fb9 <+118>:	mov    $0x137,%eax
   0x0000000000400fbe <+123>:	cmp    0xc(%rsp),%eax
   0x0000000000400fc2 <+127>:	je     0x400fc9 <phase_3+134>
   0x0000000000400fc4 <+129>:	callq  0x40143a <explode_bomb>
   0x0000000000400fc9 <+134>:	add    $0x18,%rsp
   0x0000000000400fcd <+138>:	retq
End of assembler dump.
```
The return value of the c function is always storaged in the eax, so the `0x0000000000400f56 <+19>:	mov    $0x0,%eax`
compare the number of the parameters and the 0x1,it must be bigger than 1.
So we can input two numbers.
The first number must be less than 7,if the number is 1, it will jump to the `0x0000000000400f81`. In this statement we can see the second number is 311.
综上所述，我们可以看到最终一个可行的结果是`1 311`
你也可以选择其他的分支，按照相同的方法得到结果

### 2.4 bomb four
```shell
 0x0000000000401029 <+29>:	cmp    $0x2,%eax
```
In this place, we can see the number of the parameters should be two.

```shell
0x000000000040102e <+34>:	cmpl   $0xe,0x8(%rsp)
0x0000000000401033 <+39>:	jbe    0x40103a <phase_4+46>
```
The phase_4:
```shell
=> 0x000000000040100c <+0>:	sub    $0x18,%rsp
   0x0000000000401010 <+4>:	lea    0xc(%rsp),%rcx
   0x0000000000401015 <+9>:	lea    0x8(%rsp),%rdx
   0x000000000040101a <+14>:	mov    $0x4025cf,%esi
   0x000000000040101f <+19>:	mov    $0x0,%eax
   0x0000000000401024 <+24>:	callq  0x400bf0 <__isoc99_sscanf@plt>
   0x0000000000401029 <+29>:	cmp    $0x2,%eax
   0x000000000040102c <+32>:	jne    0x401035 <phase_4+41>
   0x000000000040102e <+34>:	cmpl   $0xe,0x8(%rsp) ; The first number should be less than 15
   0x0000000000401033 <+39>:	jbe    0x40103a <phase_4+46>
   0x0000000000401035 <+41>:	callq  0x40143a <explode_bomb>
   0x000000000040103a <+46>:	mov    $0xe,%edx
   0x000000000040103f <+51>:	mov    $0x0,%esi
   0x0000000000401044 <+56>:	mov    0x8(%rsp),%edi
   0x0000000000401048 <+60>:	callq  0x400fce <func4>
   0x000000000040104d <+65>:	test   %eax,%eax
   0x000000000040104f <+67>:	jne    0x401058 <phase_4+76>
   0x0000000000401051 <+69>:	cmpl   $0x0,0xc(%rsp)
   0x0000000000401056 <+74>:	je     0x40105d <phase_4+81>
   0x0000000000401058 <+76>:	callq  0x40143a <explode_bomb>
   0x000000000040105d <+81>:	add    $0x18,%rsp
   0x0000000000401061 <+85>:	retq

```

So the first number should be bigger than 14. In the phase_4, you can 
see the required return number should be zero.And the second parameter 
should the zero, the first number should make the func4(0x0, 0xe, x) as 0

```shell
; func4
; first call is func4(edx=a, esi=b, edi=x)
=> 0x0000000000400fce <+0>:	sub    $0x8,%rsp
   0x0000000000400fd2 <+4>:	mov    %edx,%eax ; eax = a
   0x0000000000400fd4 <+6>:	sub    %esi,%eax ; eax = a - b = t1
   0x0000000000400fd6 <+8>:	mov    %eax,%ecx ; ecx = eax = t1
   0x0000000000400fd8 <+10>:	shr    $0x1f,%ecx ; ecx = ecx >> 31 = t1 >> 31 = t2
   0x0000000000400fdb <+13>:	add    %ecx,%eax ; eax = eax + ecx = t2 + t1
   0x0000000000400fdd <+15>:	sar    %eax ; eax = eax >> 1 it is equal to the (t2 + t1)>>1 t1 = (t1 + t2)>>1;
   0x0000000000400fdf <+17>:	lea    (%rax,%rsi,1),%ecx ; ecx = eax + esi = t1 + b ,t2=t1+b
   ; because the ecx can only fit the 16
   0x0000000000400fe2 <+20>:	cmp    %edi,%ecx ; ecx <= x?() :(2*func4())
   ;
   0x0000000000400fe4 <+22>:	jle    0x400ff2 <func4+36>
   0x0000000000400fe6 <+24>:	lea    -0x1(%rcx),%edx ; edx = ecx - 1
   0x0000000000400fe9 <+27>:	callq  0x400fce <func4>
   0x0000000000400fee <+32>:	add    %eax,%eax ; (2*func4())
   0x0000000000400ff0 <+34>:	jmp    0x401007 <func4+57>
   0x0000000000400ff2 <+36>:	mov    $0x0,%eax ; eax = 0
   0x0000000000400ff7 <+41>:	cmp    %edi,%ecx ; ecx >= edi ? (return 0) : ()
   0x0000000000400ff9 <+43>:	jge    0x401007 <func4+57>
   0x0000000000400ffb <+45>:	lea    0x1(%rcx),%esi
   0x0000000000400ffe <+48>:	callq  0x400fce <func4>
   0x0000000000401003 <+53>:	lea    0x1(%rax,%rax,1),%eax
   0x0000000000401007 <+57>:	add    $0x8,%rsp
   0x000000000040100b <+61>:	retq

```
All in all, the ans can be 0,0 ...

## 2.5 The bomb five 
```shell
=> 0x0000000000401062 <+0>:	push   %rbx ;push the function into the  
   0x0000000000401063 <+1>:	sub    $0x20,%rsp; sub 20 from the rsp 
   0x0000000000401067 <+5>:	mov    %rdi,%rbx ; rbx = rdi 
   0x000000000040106a <+8>:	mov    %fs:0x28,%rax; 
   0x0000000000401073 <+17>:	mov    %rax,0x18(%rsp)
   0x0000000000401078 <+22>:	xor    %eax,%eax
   0x000000000040107a <+24>:	callq  0x40131b <string_length>
   0x000000000040107f <+29>:	cmp    $0x6,%eax
   0x0000000000401082 <+32>:	je     0x4010d2 <phase_5+112>
   0x0000000000401084 <+34>:	callq  0x40143a <explode_bomb>
   0x0000000000401089 <+39>:	jmp    0x4010d2 <phase_5+112>
   0x000000000040108b <+41>:	movzbl (%rbx,%rax,1),%ecx
   0x000000000040108f <+45>:	mov    %cl,(%rsp)
   0x0000000000401092 <+48>:	mov    (%rsp),%rdx
   0x0000000000401096 <+52>:	and    $0xf,%edx ; Get the first four bit from the edx. 
   0x0000000000401099 <+55>:	movzbl 0x4024b0(%rdx),%edx ; Get the index, storaged in the 0x4024b0 is  maduiersnfotvbyl
   0x00000000004010a0 <+62>:	mov    %dl,0x10(%rsp,%rax,1)
   0x00000000004010a4 <+66>:	add    $0x1,%rax
   0x00000000004010a8 <+70>:	cmp    $0x6,%rax
   0x00000000004010ac <+74>:	jne    0x40108b <phase_5+41>
   0x00000000004010ae <+76>:	movb   $0x0,0x16(%rsp)
   0x00000000004010b3 <+81>:	mov    $0x40245e,%esi ; Storaged in the 0x40245e is 0x40245e
   0x00000000004010b8 <+86>:	lea    0x10(%rsp),%rdi
   0x00000000004010bd <+91>:	callq  0x401338 <strings_not_equal>
   0x00000000004010c2 <+96>:	test   %eax,%eax
   0x00000000004010c4 <+98>:	je     0x4010d9 <phase_5+119>
   0x00000000004010c6 <+100>:	callq  0x40143a <explode_bomb>
   0x00000000004010cb <+105>:	nopl   0x0(%rax,%rax,1)
   0x00000000004010d0 <+110>:	jmp    0x4010d9 <phase_5+119>
   0x00000000004010d2 <+112>:	mov    $0x0,%eax
   0x00000000004010d7 <+117>:	jmp    0x40108b <phase_5+41>
   0x00000000004010d9 <+119>:	mov    0x18(%rsp),%rax
   0x00000000004010de <+124>:	xor    %fs:0x28,%rax
   0x00000000004010e7 <+133>:	je     0x4010ee <phase_5+140>
   0x00000000004010e9 <+135>:	callq  0x400b30 <__stack_chk_fail@plt>
   0x00000000004010ee <+140>:	add    $0x20,%rsp
   0x00000000004010f2 <+144>:	pop    %rbx
   0x00000000004010f3 <+145>:	retq
```
So this bomb, we have a hash map 
maduiersnfotvbyl 
So the flyers's numbers are 9, 15, 14, 5, 6 
Then we can use the `man ascii|grep number` to get the char that and 0xf = number 























