# Linux中截屏实现
[TOC]
在mac和windows中都有游戏诶快捷键区进行截屏，但是在linux中我们可以使用命令行进行实现
## 0. pre work
安装我们的截屏工具
```shell
sudo apt install scrot 
```
### 1.对整个屏幕进行截屏
```shell
scrot
```
在截屏时候设置输出
```shell
scrot ~/Pictures/my_desktop.png
```
### 2.设置特定区域的截屏
```shell
scrot -s 
```
你可以继续在后面设置-d的参数代表在多少秒之后进行截屏

### 3.其他的设置
通过设置-q的参数可以设置截屏的质量
使用-t的参数可以对截屏进行放缩