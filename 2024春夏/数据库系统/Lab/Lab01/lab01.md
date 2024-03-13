# 实验一：DBMS的安装和使用

## 实验目的

1. 通过安装某个数据库管理系统，初步了解DBMS的运行环境。
2. 了解DBMS交互界面、图形界面和系统管理工具的使用。
3. 搭建实验平台。

## 实验环境

1. 操作系统：Windows
2. 数据库管理系统：MySQL

## 实验流程

### 安装MySQL，并配置环境变量

![image-20240227113849906](C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240227113849906.png)

### 熟悉基本功能

1. 连接与登录

   在命令行中输入`mysql -u root -p`，输入密码后回车完成登录：

   ![image-20240227114005436](C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240227114005436.png)

2. 查看数据库：

   输入`show databases;`

   <img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240227114134579.png" alt="image-20240227114134579" style="zoom:50%;" />

3. 创建一个新的数据库，并执行一些操作

   输入`create database db0;`

   ![image-20240227115101230](C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240227115101230.png)

   输入以下代码：

   ```sql
   mysql> use db0;
   mysql> create table student(id int not null primary key, age int, name 
   varchar(16));
   mysql> insert into student values(1, 21, 'hello'), (2, 22, 'world');
   mysql> select * from student；
   ```

   ![image-20240227115207431](C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240227115207431.png)

4. 完成后输入`exit`退出数据库

   <img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240227115306252.png" alt="image-20240227115306252" style="zoom:50%;" />

## 遇到的问题及解决方法

无

## 总结

本次实验是基本实验平台的搭建，熟悉了数据库的基本功能使用，过程比较顺利。