# COLORFUL World
在使用终端工具的时候，我们经常可以看到有颜色的输出
这些颜色的输出其实可以直接在我们的输出文本前后加上限定的修饰，就可以实现
```c
# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
# Clear the color after that
clear='\033[0m'
上面大概就是我们的输出颜色的代码
```
在平时的输出中，我们输出的格式大概是
\${color}text\${clear}
大致按照下面demo进行写代码就可以得到有颜色的输出，终端中有颜色的输出可能也是这种原理，但是还是想不通为司马使用head的时候会卡掉颜色的输出

```c
#include <stdio.h>
// # Color variables
// red='\033[0;31m'
// green='\033[0;32m'
// yellow='\033[0;33m'
// blue='\033[0;34m'
// magenta='\033[0;35m'
// cyan='\033[0;36m'
// # Clear the color after that
// clear='\033[0m'
int main() {
    printf("\033[1;31mThis is the red\033[0m\n");
    printf("\033[1;31mThis is bold red text\033[0m\n");
}
```