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
   0x0000000000401096 <+52>:	and    $0xf,%edx
   0x0000000000401099 <+55>:	movzbl 0x4024b0(%rdx),%edx
   0x00000000004010a0 <+62>:	mov    %dl,0x10(%rsp,%rax,1)
   0x00000000004010a4 <+66>:	add    $0x1,%rax
   0x00000000004010a8 <+70>:	cmp    $0x6,%rax
   0x00000000004010ac <+74>:	jne    0x40108b <phase_5+41>
   0x00000000004010ae <+76>:	movb   $0x0,0x16(%rsp)
   0x00000000004010b3 <+81>:	mov    $0x40245e,%esi
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
## 2.6 bomb six
```shell
Dump of assembler code for function phase_6:
=> 0x00000000004010f4 <+0>:	push   %r14
   0x00000000004010f6 <+2>:	push   %r13
   0x00000000004010f8 <+4>:	push   %r12
   0x00000000004010fa <+6>:	push   %rbp
   0x00000000004010fb <+7>:	push   %rbx
   0x00000000004010fc <+8>:	sub    $0x50,%rsp
   0x0000000000401100 <+12>:	mov    %rsp,%r13
   0x0000000000401103 <+15>:	mov    %rsp,%rsi
   0x0000000000401106 <+18>:	callq  0x40145c <read_six_numbers>
   0x000000000040110b <+23>:	mov    %rsp,%r14
   0x000000000040110e <+26>:	mov    $0x0,%r12d ; set the r12dv to be the zero 
   0x0000000000401114 <+32>:	mov    %r13,%rbp ; 
   0x0000000000401117 <+35>:	mov    0x0(%r13),%eax ; move the first number to the eax 
   0x000000000040111b <+39>:	sub    $0x1,%eax ; eax -= 1
   0x000000000040111e <+42>:	cmp    $0x5,%eax ; the first number - 1 should be less or equal to the 5
   0x0000000000401121 <+45>:	jbe    0x401128 <phase_6+52> 
   0x0000000000401123 <+47>:	callq  0x40143a <explode_bomb> 
   0x0000000000401128 <+52>:	add    $0x1,%r12d ; r12d++ so we guess it is a count 
   0x000000000040112c <+56>:	cmp    $0x6,%r12d ; when the r12d is eual to the 6, the loop will end, so the loop
   ; is for (int i = 1;i <= 6;i++) so we name the r12d as the i 
   0x0000000000401130 <+60>:	je     0x401153 <phase_6+95> ; 
   0x0000000000401132 <+62>:	mov    %r12d,%ebx ; move the i to the edx 
   0x0000000000401135 <+65>:	movslq %ebx,%rax ; move the i to the rax 
   0x0000000000401138 <+68>:	mov    (%rsp,%rax,4),%eax ; move the a[i] to the eax 
   0x000000000040113b <+71>:	cmp    %eax,0x0(%rbp) ; complare the eax with the rbp  
   0x000000000040113e <+74>:	jne    0x401145 <phase_6+81> ; If the eax is equal to the complared elemeny, the bomb will be explored 
   0x0000000000401140 <+76>:	callq  0x40143a <explode_bomb>
   0x0000000000401145 <+81>:	add    $0x1,%ebx ; we can set the ebx to be the j, so this loop 
   ; for (int j = 1;j <= 5;j++) 
   ; 结合起来大概就是
   ; for (int i = 0;i < 6;i++) {
   ;    if(a[i] > 6 ) bomded  
   ;    for (int j = i + 1;j <= 5;j++) 
   ;        if(a[i] == a[j]) bomded
   }
   ; So the consulation is that every elem should be different adn in the range(0,6)  
   0x0000000000401148 <+84>:	cmp    $0x5,%ebx 
   0x000000000040114b <+87>:	jle    0x401135 <phase_6+65>
   0x000000000040114d <+89>:	add    $0x4,%r13
   0x0000000000401151 <+93>:	jmp    0x401114 <phase_6+32>
   0x0000000000401153 <+95>:	lea    0x18(%rsp),%rsi
   ; 0x18 = 24, so it send the sixth number to the rsi
   0x0000000000401158 <+100>:	mov    %r14,%rax
   ; r14 is the address of teh first elem. then we pass it to the rax 
   0x000000000040115b <+103>:	mov    $0x7,%ecx
   ; ecx = 7 
   0x0000000000401160 <+108>:	mov    %ecx,%edx
   ; edx = 7 
   0x0000000000401162 <+110>:	sub    (%rax),%edx
   ; edx = 7 - rax 
   0x0000000000401164 <+112>:	mov    %edx,(%rax)
   ; rax = edx 
   0x0000000000401166 <+114>:	add    $0x4,%rax
   ; As the rax is the address of the array, so the +4 will make it point to the next elem 
   0x000000000040116a <+118>:	cmp    %rsi,%rax
   ; rsi is the last number of the array, so this judge is made to see whether it has achieve the last number
   0x000000000040116d <+121>:	jne    0x401160 <phase_6+108>
   ; After it achieve the last elem, the loop will be stop.  
   0x000000000040116f <+123>:	mov    $0x0,%esi
   ; esi = 0  
   0x0000000000401174 <+128>:	jmp    0x401197 <phase_6+163i>
   0x0000000000401176 <+130>:	mov    0x8(%rdx),%rdx ; rdx = rdx + 8
   0x000000000040117a <+134>:	add    $0x1,%eax; it is also a count 
   0x000000000040117d <+137>:	cmp    %ecx,%eax  ; complare the eax with ecx 
   0x000000000040117f <+139>:	jne    0x401176 <phase_6+130> ; it will run 6 times 
   0x0000000000401181 <+141>:	jmp    0x401188 <phase_6+148> ; The it will jump to 148 
   0x0000000000401183 <+143>:	mov    $0x6032d0,%edx
   0x0000000000401188 <+148>:	mov    %rdx,0x20(%rsp,%rsi,2) ; 
   0x000000000040118d <+153>:	add    $0x4,%rsi ; 
   0x0000000000401191 <+157>:	cmp    $0x18,%rsi
   0x0000000000401195 <+161>:	je     0x4011ab <phase_6+183>
   0x0000000000401197 <+163>:	mov    (%rsp,%rsi,1),%ecx
   0x000000000040119a <+166>:	cmp    $0x1,%ecx
   0x000000000040119d <+169>:	jle    0x401183 <phase_6+143>
   0x000000000040119f <+171>:	mov    $0x1,%eax
   0x00000000004011a4 <+176>:	mov    $0x6032d0,%edx
   0x00000000004011a9 <+181>:	jmp    0x401176 <phase_6+130>
   0x00000000004011ab <+183>:	mov    0x20(%rsp),%rbx
   0x00000000004011b0 <+188>:	lea    0x28(%rsp),%rax
   0x00000000004011b5 <+193>:	lea    0x50(%rsp),%rsi
   0x00000000004011ba <+198>:	mov    %rbx,%rcx
   0x00000000004011bd <+201>:	mov    (%rax),%rdx
   0x00000000004011c0 <+204>:	mov    %rdx,0x8(%rcx)
   0x00000000004011c4 <+208>:	add    $0x8,%rax
   0x00000000004011c8 <+212>:	cmp    %rsi,%rax
   0x00000000004011cb <+215>:	je     0x4011d2 <phase_6+222>
   0x00000000004011cd <+217>:	mov    %rdx,%rcx
   0x00000000004011d0 <+220>:	jmp    0x4011bd <phase_6+201>
   0x00000000004011d2 <+222>:	movq   $0x0,0x8(%rdx)
   0x00000000004011da <+230>:	mov    $0x5,%ebp
   0x00000000004011df <+235>:	mov    0x8(%rbx),%rax
   0x00000000004011e3 <+239>:	mov    (%rax),%eax
   0x00000000004011e5 <+241>:	cmp    %eax,(%rbx)
   0x00000000004011e7 <+243>:	jge    0x4011ee <phase_6+250>
   0x00000000004011e9 <+245>:	callq  0x40143a <explode_bomb>
   0x00000000004011ee <+250>:	mov    0x8(%rbx),%rbx
   0x00000000004011f2 <+254>:	sub    $0x1,%ebp
   0x00000000004011f5 <+257>:	jne    0x4011df <phase_6+235>
   0x00000000004011f7 <+259>:	add    $0x50,%rsp
   0x00000000004011fb <+263>:	pop    %rbx
   0x00000000004011fc <+264>:	pop    %rbp
   0x00000000004011fd <+265>:	pop    %r12
   0x00000000004011ff <+267>:	pop    %r13
   0x0000000000401201 <+269>:	pop    %r14
   0x0000000000401203 <+271>:	retq
End of assembler dump.

```
The value and the index of the node is 
332 168 924 691 477 443
6   5   4   3   2   1
After sort it 
5 6 1 2 3 4

The ans is 4 3 2 1 6 5





















