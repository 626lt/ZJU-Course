#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 实验报告

  #set text(font: ("Linux Libertine", "LXGW WenKai Mono"))
  #v(2cm)
  #set text(size: 15pt)
  #grid(
    columns: (80pt, 180pt),
    rows: (27pt, 27pt, 27pt, 27pt),
    [姓名：], [#uline[刘韬]],
    [学院：], [#uline[竺可桢学院]],
    [专业：], [#uline[人工智能]],
    [邮箱：], [#uline[3220103422\@zju.edu.cn]],
  )

  #v(2cm)
  #set text(size: 18pt)
  #grid(
    columns: (100pt, 200pt),
    [报告日期：], [#uline[2024年3月29日]],
  )

  #pagebreak()
]
#show: doc=>jizu(doc)

== 建立表，考察表的生成者拥有该表的哪些权限。

首先，我们知道root用户具有所有的权限，现在我们新建一个用户，让他生成表，考察他的权限。
```sql
create user'testuser'@'localhost'identified by'123456';
```
接着我们在sql内切换到testuser用户，然后创建一个数据库，再创建一个表。
#figure(image("2024-04-05-22-06-23.png"))
为此，我们需要回到root用户为其授权：
```sql
grant create on *.* to 'testuser'@'localhost';
```
现在切换回testuser用户，查看权限
```sql
show grants;
```
#figure(image("2024-04-05-23-48-30.png"))
然后新建一个表，查看权限
```sql
create table test1(
id char(10),
name char(15),
primary key(id)
);
```
#figure(image("2024-04-05-23-54-11.png"))
可以看到，用户testuser仅对表test1有create权限，其余权限均没有。而root用户具有全部权限

== 使用SQL 的grant 和revoke命令对其他用户进行授权和权力回收，考察相应的作用。

在root用户执行下面语句：
```sql
grant select on lab4.test1 to 'testuser'@'localhost';
```
我们发现testuser用户可以查询表test1，拥有了select权限
#figure(image("2024-04-06-00-00-00.png.png"))
接着我们执行下面语句：
```sql
revoke select on lab4.test1 from 'testuser'@'localhost';
```
再次查询，发现testuser用户没有select权限
#figure(image("2024-04-06-00-01-32.png"))
至此，我们考察了grant和revoke命令的作用

== 建立视图，并把该视图的查询权限授予其他用户，考察通过视图进行权限控制的作用。

首先我们在root用户下创建一个视图
```sql
create view tt 
as 
	select id
    from test1
    where id = 1;
```
再把视图的查询权限授予testuser用户
```sql
grant select on lab4.tt to "testuser"@"localhost";
```
用testuser1身份查询该视图：
#figure(image("2024-04-06-00-07-40.png"))
可以看到执行成功了，视图在这里的作用就是给相应的权限进行分级，然后进行授予，这样就可以实现权限控制

== 总结

本次实验主要是实践权限的授予与收回，主要使用了grant和revoke两个命令，让我对权限的控制有了更深的理解，同时也学会了如何使用视图进行权限控制，这对帮助我理解数据库的安全性有很大的帮助。