# GCC tutorial
## 1. simple compile
```gcc
gcc hello.c 
``` 
Then you will get the a.out 
```shell
chmod +x hello.c 
./a.out 
```
You can execute the `a.out`by using the code above 

## 2. name the output
```shell
gcc -o hello hello.c 
```
then you will get a output named hello

## 3. compile the file by step
```shell
gcc -S hello.c -o  hello.s
gcc -c hello.s -o hello.o
gcc hello.o -o prog 
```
gcc complie to the *.s ,the as process it into *.o, the ld process it to the executable file 
