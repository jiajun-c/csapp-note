# Data Lab

[TOC]

## 1.bitXor

要求:使用非和或实现一个与

思路: 当x和y中的某一位都为0/1的时候,异或后该位置为0,否则为1,x&y得到在两边都为1的的二进制,(\~x&\~y )得到两边都为0的二进制表示,将两个全部取反之后并一下得到的就是Xor

```c
int bitXor(int x,int y) {
    return (~(x&y))&(~(~x&~y));
}
```

## 2.tmin

要求:得到对2补码的最小int值

思路:int的最小值其实就是0x10000000,即-2^31

```c
int tmin(void) {
  return 1<<31;
}
```

## 3.isTmax(x) 

要求: 判断x是否是对的2的最大补码

思路:2的最大补码其实就是0x7fffffff设其为m,m+1 = 0x80000000,m*(m+1) = 0即可说明其为最大补码,我们还需要去特判一下x=-1这种情况 

```c
int isTmax(int x) {
    return (!(~(x+x+1)))&&(x+1);
}
```

## 4.allOddBits(x)

要求:判断是否所有的奇数位都为1

思路:得到一个全部奇数位都为1的数,然后和x进行比较

```c
int allOddBits(int x) {
    int y = 0xAA;
    y |= (y<<8);
    y |= (y<<16);
    return !(x - y);
}
```

## 5.negate(x)

要求:不使用-x得到-x

思路:直接取补码就可

```c
int negate(int x) {
    return ~x + 1;
}
```

## 6.isAsciiDigit(x)

要求:判断输入的x是否为数字0~9的ASCII码

思路:我们的0-9的ASCII码都在0x30-0x39之间,所以&上0xc8一定为0,如果不为0,则错误,同时还需要判断在高位上是否只有0x3

```c
int isAsciiDigit(int x) {
    return (!(x&(0xc8)))&(!((x>>4)-0x3));
}
```



## 7.conditional(x, y, z)

要求:实现三目运算符

思路: 将x转换为bool后直接进行运算

```c
int conditional(int x, int y, int z){
    x = !!x;
    return x&y + (!x)&z;
}
```



## 8.isLessOrEqual(x,y)

要求:实现小于等于

思路:直接用x - y,判断符号位,如果符号位为1,则为小于,否则为大于

```c
int isLessOrEqual(int x, int y) {
  int negX=~x+1;//-x
  int addX=negX+y;//y-x
  int checkSign = addX>>31&1; //y-x的符号
  int leftBit = 1<<31;//最大位为1的32位有符号数
  int xLeft = x&leftBit;//x的符号
  int yLeft = y&leftBit;//y的符号
  int bitXor = xLeft ^ yLeft;//x和y符号相同标志位，相同为0不同为1
  bitXor = (bitXor>>31)&1;//符号相同标志位格式化为0或1
  return ((!bitXor)&(!checkSign))|(bitXor&(xLeft>>31));//返回1有两种情况：符号相同标志位为0（相同）位与 y-x 的符号为0（y-x>=0）结果为1；符号相同标志位为1（不同）位与x的符号位为1（x<0）
}
```

## 9.logicalNeg(x)

要求:实现!x without !

思路:除0外所有负数和正数的负数都是符号位为1的

```c
int logicalNeg(int x) {
    if(x&(1<<31)) return 1;
    if(-x&(1<<31)) return 1;
    return 0;
}
```



## 10.howManyBits(x) 

要求:求一个数用补码表示需要多少位

思路:去判断它的最高位所在的位置

```c
int howManyBits(int x) {
  int b16,b8,b4,b2,b1,b0;
  int sign=x>>31;
  x = (sign&~x)|(~sign&x);
  b16 = !!(x>>16)<<4;//高十六位是否有1
  x = x>>b16;//如果有（至少需要16位），则将原数右移16位
  b8 = !!(x>>8)<<3;//剩余位高8位是否有1
  x = x>>b8;//如果有（至少需要16+8=24位），则右移8位
  b4 = !!(x>>4)<<2;//同理
  x = x>>b4;
  b2 = !!(x>>2)<<1;
  x = x>>b2;
  b1 = !!(x>>1);
  x = x>>b1;
  b0 = x;
  return b16+b8+b4+b2+b1+b0+1;//+1表示加上符号位
}
```

## 11.floatScale2(f)

要求: 求2乘以一个浮点数

思路: 浮点数分为符号位和指数位以及尾数部分,首先我们的指数部分和符号位,如果这个指数已经到达最高位为inf,直接返回即可,如果加一之后为255直接返回人工得到的inf,否则将指数位加一后进行组合得到最终的结果

```c
unsigned floatScale2(unsigned uf) {
  int exp = (uf&0x7f800000)>>23;
  int sign = uf&(1<<31);
  if(exp==0) return uf<<1|sign;
  if(exp==255) return uf;
  exp++;
  if(exp==255) return 0x7f800000|sign;
  return (exp<<23)|(uf&0x807fffff);
}
```

## 12.floatFloat2Int(f)

要求:将浮点数转换为整数

思路:得到指数位和尾数位,符号位,然后去判断有无溢出

```c
int floatFloat2Int(unsigned uf) {
  int e = ((uf >> 23) & 0xff)-127;
  int sign = uf >> 31;
  int M = (uf&0x007fffff)|0x00800000;
  if(!(uf&0x7fffffff)) return 0; // 0
  if(e < 0) return 0; // 0.***
  if(e > 31) return 0x80000000; // overflow
  if(!(uf & 0x7fffffff)) return 0; // 0
  /* 取整数部分 */
  if(e > 23)
    M <<= (e - 23);
  else
    M >>= (23 - e);
  if(!((M >> 31) ^ sign)) // +
    return M;
  else if(M >> 31) // overflow
    return 0x80000000;
  return ~M + 1; // -
}
```

## 13.floatPower2(x)

要求:得到我们的$2.0^x$

思路:直接将x放到我们的符号位置即可

```c
unsigned floatPower2(int x) {
  int INF = 0xff<<23;
  int exp = x + 127;
  if(exp <= 0) return 0;
  if(exp >= 255) return INF;
  return exp << 23;
}
```

# The whole

```c
int bitXor(int x,int y) {
    return (~(x&y))&(~(~x&~y));
}
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
  return 1<<31;
}
//2
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x) {
  int i = x+1;//Tmin,1000...
  x=x+i;//-1,1111...
  x=~x;//0,0000...
  i=!i;//exclude x=0xffff...
  x=x+i;//exclude x=0xffff...
  return !x;
}
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   where bits are numbered from 0 (least significant) to 31 (most significant)
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
  int mask = 0xAA+(0xAA<<8);
  mask=mask+(mask<<16);
  return !((mask&x)^mask);
}
/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x) {
    return ~x + 1;
}
//3
/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
  int sign = 0x1<<31;
  int upperBound = ~(sign|0x39);
  int lowerBound = ~0x30;
  upperBound = sign&(upperBound+x)>>31;
  lowerBound = sign&(lowerBound+1+x)>>31;
  return !(upperBound|lowerBound);
}
/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
  x = !!x;
  x = ~x+1;
  return (x&y)|(~x&z);
}
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
// int isLessOrEqual(int x,int y) {
//     int l = x>>31;
//     int r = y>>31;
//     y = ~y + 1;
//     return (((!r)&l)|((x+y)>>31)&1|!(x+y))&(r&(!l));
// }
int isLessOrEqual(int x, int y) {
  int negX=~x+1;//-x
  int addX=negX+y;//y-x
  int checkSign = addX>>31&1; //y-x的符号
  int leftBit = 1<<31;//最大位为1的32位有符号数
  int xLeft = x&leftBit;//x的符号
  int yLeft = y&leftBit;//y的符号
  int bitXor = xLeft ^ yLeft;//x和y符号相同标志位，相同为0不同为1
  bitXor = (bitXor>>31)&1;//符号相同标志位格式化为0或1
  return ((!bitXor)&(!checkSign))|(bitXor&(xLeft>>31));//返回1有两种情况：符号相同标志位为0（相同）位与 y-x 的符号为0（y-x>=0）结果为1；符号相同标志位为1（不同）位与x的符号位为1（x<0）
}
//4
/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int logicalNeg(int x) {
    return ((x|(~x+1))>>31)+1;
}
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
  int b16,b8,b4,b2,b1,b0;
  int sign=x>>31;
  x = (sign&~x)|(~sign&x);
  b16 = !!(x>>16)<<4;//高十六位是否有1
  x = x>>b16;//如果有（至少需要16位），则将原数右移16位
  b8 = !!(x>>8)<<3;//剩余位高8位是否有1
  x = x>>b8;//如果有（至少需要16+8=24位），则右移8位
  b4 = !!(x>>4)<<2;//同理
  x = x>>b4;
  b2 = !!(x>>2)<<1;
  x = x>>b2;
  b1 = !!(x>>1);
  x = x>>b1;
  b0 = x;
  return b16+b8+b4+b2+b1+b0+1;//+1表示加上符号位
}
//float
/* 
 * floatScale2 - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int floatFloat2Int(unsigned uf) {
  int e = ((uf >> 23) & 0xff)-127;
  int sign = uf >> 31;
  int M = (uf&0x007fffff)|0x00800000;
  if(!(uf&0x7fffffff)) return 0; // 0
  if(e < 0) return 0; // 0.***
  if(e > 31) return 0x80000000; // overflow
  if(!(uf & 0x7fffffff)) return 0; // 0
  /* 取整数部分 */
  if(e > 23)
    M <<= (e - 23);
  else
    M >>= (23 - e);
  if(!((M >> 31) ^ sign)) // +
    return M;
  else if(M >> 31) // overflow
    return 0x80000000;
  return ~M + 1; // -
}
/* 
 * floatFloat2Int - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned floatPower2(int x) {
  int INF = 0xff<<23;
  int exp = x + 127;
  if(exp <= 0) return 0;
  if(exp >= 255) return INF;
  return exp << 23;
}
/* 
 * floatPower2 - Return bit-level equivalent of the expression 2.0^x
 *   (2.0 raised to the power x) for any 32-bit integer x.
 *
 *   The unsigned value that is returned should have the identical bit
 *   representation as the single-precision floating-point number 2.0^x.
 *   If the result is too small to be represented as a denorm, return
 *   0. If too large, return +INF.
 * 
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. Also if, while 
 *   Max ops: 30 
 *   Rating: 4
 */
unsigned floatScale2(unsigned uf) {
  int exp = (uf&0x7f800000)>>23;
  int sign = uf&(1<<31);
  if(exp==0) return uf<<1|sign;
  if(exp==255) return uf;
  exp++;
  if(exp==255) return 0x7f800000|sign;
  return (exp<<23)|(uf&0x807fffff);
}
```

