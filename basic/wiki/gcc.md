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

## 4. The Optimization
> usagae
```shell
gcc -O2 -S test.s test.c
```
The gcc has some optimization like the O1, O2
If you do not use the optimization, the compiler's goal is to reduce the time of the compilation and to make the debugging produce the expected results.

Turning on the optimization flags makes the compiler attempt toimprove the performance and/or code size at the cost of the complication time and the possiblity to debug the program.

The difference of the O2 and O1 is that the O2 turn on more optimization flags than O1.

And the O3 turns on more flags than the O2

-0s
Optimize for size, -0s enables all -O2 optimizations expect those that often increase code size.

If you wants to learn more about the optimization, go [this](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html)

You should be attention that the O2/O1... will clear some code that isn't execulte.

Like if there is a function but the function isn't used in the program ,it will not be compile