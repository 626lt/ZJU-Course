#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业5

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
    [日期：], [#uline[2024年3月29日]],
  )

  #pagebreak()
]

#show: doc => dbhw(doc)

== 4.7

=== employee(#underline()[ID], person_name, street, city)

```sql
create table employee(
    ID int primary key,
    person_name varchar(20),
    street varchar(20),
    city varchar(20)
);
```

=== company(#underline()[company_name], city)

```sql
create table company(
    company_name varchar(20) primary key,
    city varchar(20)
);
```

=== works(#underline()[ID], company_name, salary)

```sql
create table works(
    ID int primary key,
    company_name varchar(20),
    salary numeric(10,2),
    foreign key (ID) references employee(ID),
    foreign key (company_name) references company(company_name)
);
```

=== manages(#underline()[ID], manager_ID)

```sql
create table manages(
    ID int primary key,
    manager_ID int,
    foreign key (ID) references employee(ID),
    foreign key (manager_ID) references employee(ID)
);
```

== 4.9

这个经理的所有员工的元组，在所有的levels都会被删除。最开始删除与该经理直接员工对应的元组，这些删除反过来导致删除二级员工元组，以此类推，直到删除所有直接和间接员工元组。

== 4.12

如果授权是基于当前角色完成的，则即使执行授权的用户离开并且这个账户被终止了，授权仍然有效。这可以减小用户账户被终止带来的连锁影响。通过角色而非用户来管理权限可以更好地维护数据库。