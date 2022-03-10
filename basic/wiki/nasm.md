# Using nasm and gcc to run you .asm
## 1. complie 
```shell
> nasm -f -elf64 test.asm
> nasm -f -elf32 test.asm # this is in the 32 mode 
```

## 2. link
```shell
link -s -o test test.asm
```
If you use the command above, you may not be able to run it

```shell
gcc -g -o test test.o
```
