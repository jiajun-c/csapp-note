# GDB 调试
[TOC]
## 0. pre work
在一些文章中看到需要在编译的时候加入-g的参数才能进行调试
加入gdb参数的编译指令如下
```gdb
gcc -g -o hello hello.c 
```
### 0.1 check file
我们可以使用readelf对[elf](./wiki/ELF.md)文件进行查看,使用grep我们可以抓取到我们想要的信息
```shell
>linux readelf -S hello|grep plt  
  [11] .rela.plt         RELA             0000000000000608  00000608
  [13] .plt              PROGBITS         0000000000001020  00001020
  [14] .plt.got          PROGBITS         0000000000001050  00001050
  [15] .plt.sec          PROGBITS         0000000000001060  00001060

```
编译产生可执行文件后对其进行调试
按道理说到这里我们已经可以看出这个程序是否是可以调试的，但是原文的作者还教会了我们另外一种方式
`file hello|grep strip`
在得到的信息中如果显示not stripped说明调试相关的信息没有被抹除，还保存在文件中，否则不能进行调试

## 1 Start debug
首先让我们写一个helloworld
```c
#include<stdio.h>
int main(int argc,char *argv[])
{
    if(1 >= argc)
    {
        printf("usage:hello name\n");
        return 0;
    }
    printf("Hello World %s!\n",argv[1]);
    return 0 ;
}
```
按照上文所说启动调试之后就可以start了
### 1.1 Run 
run的基本用法和我们平时执行是差不多的，在提供了arg的情况下可以直接使用run + args的形式进行运行
```shell
(gdb) run
Starting program: /home/chengjiajun/note/csapp/code/hello 
usage:hello name
[Inferior 1 (process 48755) exited normally]
(gdb) run A
Starting program: /home/chengjiajun/note/csapp/code/hello A
Hello World A!
[Inferior 1 (process 48775) exited normally]
gdb hello 
```
也可以提前设置好arg的参数
```shell
(gdb) set args SSR
(gdb) run
Starting program: /home/chengjiajun/note/csapp/code/hello SSR
Hello World SSR!
[Inferior 1 (process 48831) exited normally]
```
### 1.2 调试core文件
当我们在机器中执行`ulimit -c` 可以查看系统是否对core文件的产生进行限制
如果结果为0，那么当程序结束的时候也不会有core文件产生。
此时我们需要进行如下的设置
[对core的调试waiting](https://www.yanbinghu.com/2018/09/26/61877.html
)

## 2 断点调试
### 2.1 查看已经存在的断点
```shell
(gdb) info breakpoints
```
### 2.2 设置断点
#### 2.2.1 在第i行设置一个断点
```shell
b 9 
```
#### 2.2.2 为一个函数设置一个断点
b [function name] 实现了在函数执行处设置断点
```shell
(gdb)b add 
```
#### 2.2.3 根据条件设置断点
```shell
(gdb) b 10 if x==11
Note: breakpoint 3 also set at pc 0x1194.
Breakpoint 4 at 0x1194: file hello.c, line 10.
(gdb) info breakpoints 
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000000001149 in add at hello.c:2
2       breakpoint     keep y   0x0000000000001161 in add at hello.c:4
3       breakpoint     keep y   0x0000000000001194 in main at hello.c:10
4       breakpoint     keep y   0x0000000000001194 in main at hello.c:10
	stop only if x==11
```

#### 2.2.4 根据规则设置断点
```shell
rbreak printNum*
```
这样就可以在所有符合规则的地方设置断点

其他断点的设置方式参考 [link](https://www.yanbinghu.com/2019/04/20/41283.html)

### 2.3 清除断点
#### 禁用或启用断点
如果加入了编号，就说明是对某一个断点进行操作，如果不仅爱如数字，就说明是对所有的断点进行的操作
```shell
(gdb)disable bnum 
(gdb)endable bnum 
```
#### 断点的清除
clear + linenum/function name/filename: function name 
```shell
(gdb) clear add

(gdb) info breakpoints 
Deleted breakpoint 1 No breakpoints or watchpoints.
(gdb) info breakpoints 
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x000000000000115b in add at hello.c:3
(gdb) d 2
(gdb) info breakpoints 
No breakpoints or watchpoints
```

## 3.变量查看
### 普通变量的查看
准备好之前的调试工具后，在相应的位置设置断点，然后在该位置程序会停下
此时`p varname`可以显示变量的值
```c
Breakpoint 4, main (argc=1, argv=0x7fffffffde58) at hello.c:10
10	    x += 1;
(gdb) p 4
$2 = 4
```
### 指针/数组的查看
如果你直接p pointname， 得到的将是地址
```shell
(gdb) p p1
$6 = (int *) 0x55555555527d <__libc_csu_init+77>
```
想要打印数组的名字，必须使用`p *pointname`（只打印第一个数字）
如果想要限定输出的数字，则需要`p *pointname@num` (将会打印数组中的前num个元素
)
>其中值得注意的一点是我们的数组名和指针其实是不同的，在gdb的打印中打印一个数组名输出的是整个数组，而打印指针输出的是地址，数组名是一种直接的访问，是真实的地址，但是对于我们的指针而言，得到的将是一个地址，运行这个地址我们可以得到真实内存所在的地方。

在一些情况下通过地址或者指针的方式区查看；变量可能会失败，这个时候我们可以使用
```shell
(gdb)  p (char*)0x4025cf
$4 = 0x4025cf "%d %d"
```
制定指针的类型
### 设置我们自己的变量
在调试的过程中，我们可以通过set指令去设置一个变量
```shell
(gdb) set $index = 1
(gdb) $index
Undefined command: "$index".  Try "help".
(gdb) index
Undefined command: "index".  Try "help".
(gdb) p y[$index]
$10 = 2
(gdb) $index++
Undefined command: "$index++".  Try "help".
(gdb) index++
Undefined command: "index++".  Try "help".
(gdb) p y[$index++]
$11 = 2
(gdb) p y[$index]
$12 = 3
```
### 进行函数的调试
```c
#include <stdio.h>
void add(int x,int y);
int main() {
  int x = 1;
  int y = 2;
  add(x,y);
}
void add(int x,int y) {
  x += y;
  printf("%d\n",x);
}
```
使用上面的代码作为例子
在对函数进行调试的时候，我们需要在函数中设置断点，然后在调用处使用`step`指令进入该函数的主体中。
If we use the `stepi`,it will go in the machine code 

### 调试中的跳转
|command|role|
|-|-|
|continue|go to the next breakpoint|
|until|go to the specific line|



### 监控变量的变化
```shell
(gdb) wathc varname
```
每次变量有变化的时候程序都会停止执行
