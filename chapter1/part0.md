# 计算机系统漫游
## 1.1 信息就是位加上下文
源程序其实就是一个由01组成的位比特，8个位被组织成一组， 称为字节，每个字节表示程序中的某些文本字符
## 1.2 程序被其他程序翻译为不同的格式
hello.c -> 预处理器 -> 编译器 -> 汇编器 -> 链接器

在预处理器中被处理为hello.i,在编译器中变为hello.c, 在汇编器中变为hello.c, 在链接器中变为可执行文件
```c
gcc -o hello hello.c 
```

## 1.3 know how it works
有必要去了解我们的程序的运行

## 1.4 处理器读并且解释储存在内存中的指令
我们直接执行可执行文件即可
`./hello`

### 1.4.1 系统的硬件组成
1. 总线
2. I/O device
3. the storage
4. the cpu 

## 1.5 高速缓存
在寄存器中对数据进行读写的速度要远快于主存储器
