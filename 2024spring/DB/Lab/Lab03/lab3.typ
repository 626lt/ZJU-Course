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
#show:doc => jizu(doc)

= 实验步骤

== 定义若干表，其中包括primary key, foreign key 和check的定义。

```sql
use lab3;

create table student(
    sid char(9) primary key,
    sname char(8),
    ssex char(2),
    sage int,
    major char(4),
    check(ssex in ('M', 'F')),
    check(sage >= 10 and sage <= 100)
);

create table enroll(
    sid char(9),
    cid char(8),
    grade int,
    primary key(sid, cid),
    foreign key(sid) references student(sid)
);
```
#figure(image("image1.png"),caption: [创建表结果])

== 让表中插入数据，考察primary key如何控制实体完整性。

```sql
insert student values('1001', 'Wang', 'M', 20, 'CS');
insert student values('1002', 'Li', 'F', 19, 'CS');
insert student values('1003', 'Zhang', 'M', 21, 'EE');
insert student values('1004', 'Zhao', 'F', 22, 'CS');
```

再插入一条主键id重复的记录
```sql
insert student values('1001', 'Ping', 'F', 22, 'CE');
```
会发生
```sql
Error Code: 1062. Duplicate entry '1001' for key 'student.PRIMARY'
```
#figure(image("image2.png"),caption: [插入重复主键的结果])

== 删除被引用表中的行，考察foreign key 中on delete 子句如何控制参照完整性。

在enroll表中插入一条引用表students中主键为"1001"的记录
```sql
insert enroll valuse('1001', 'C1', 90);
```
随后删除students表中名为wang的记录，其sid为"1001"
```sql
delete from student where sname = 'Wang';
```

报错：Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.000 sec

这是由于mysql safe mode 导致的。关闭safe mode后得到以下报错

#figure(image("image3.png"),caption: [删除被引用表中的行的结果])

Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`lab3`.`enroll`, CONSTRAINT `enroll_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`))


这体现了foreign key 中on delete子句如何控制参照完整性：只有先将表enroll中引用"1001"的记录删除后，才能删除student表中主键为"1001"的记录。

== 修改被引用表中的行的primary key，考察foreign key 中on update 子句如何控制参照完整性

```sql
update student set sid = '1005' where sname = 'wang';
```

#figure(image("image4.png"),caption: [修改被引用表中的行的primary key的结果])

Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`lab3`.`enroll`, CONSTRAINT `enroll_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`))

== 修改或插入表中数据，考察check子句如何控制校验完整性。

```sql
insert student values('1005', 'Wang', 'M', -20, 'CS')
```
#figure(image("image5.png"),caption: [插入不符合check约束的数据的结果])

报错：Error Code: 3819. Check constraint 'student_chk_2' is violated.	0.015 sec

== 定义一个asseration, 并通过修改表中数据考察断言如何控制数据完整性。

```sql
create assertion check_age check (not exists (select * from student where sage >= 50 and sage <= 100));
```
但mysql不支持assertion，所以。。。
#figure(image("image6.png"),caption: [定义断言的结果])

== 定义一个trigger, 并通过修改表中数据考察触发器如何起作用。

#figure(image("image7.png"),caption: [原先的student])
#figure(image("image8.png"),caption: [原先的enroll])

定义下面的trigger

```sql
Delimiter $$
Create trigger age_present
After update on student
For each row 
Begin
	Update enroll set grade =100
where enroll.sid in (select sid from student where sage<20);
end; $$
Delimiter ;

```

#figure(image("image9.png",width: 50%),caption: [定义触发器的结果])

可以看到trigger起作用了，当student表中的sage小于20时，enroll表中的grade被更新为100。

== 遇到的问题和解决办法

在开始写trigger定义时使用的是
```sql
Update enroll set grade =100
where enroll.sid in (select sid from student where sage<20);
```

在定义 trigger 后， update student table 出现 error 1146 : Table 'lab3.students' doesn't exist. 

#figure(image("image.png",width: 69%),caption: [遇到的问题])

这是因为这里触发了trigger，而且trigger内的sql语句中的表名写错了，应该是student而不是students。所以报错是因为找不到students表。解决方案就是把trigger修正。

== 总结

lab3验证了primary key, foreign key, check, assertion, trigger的作用，以及如何通过这些约束来保证数据的完整性。同时也遇到了一些问题，比如mysql不支持assertion，以及在定义trigger时表名写错的问题。这些告诉我使用数据库时要注意严谨，不能出现错误偏差，否则会产生意外的error。