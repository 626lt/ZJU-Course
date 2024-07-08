#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业6

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
    [日期：], [#uline[2024年4月7日]],
  )

  #pagebreak()
]

#show: doc => dbhw(doc)

== 5.6

```sql
create trigger insert_branch_cust_depositor
after insert on depositor
referencing new row as n
for each row
insert into branch_cust 
  select branch_name, n.customer_name
  from account
  where account.account_number = n.account_number;

create trigger insert_branch_cust_account
after insert on account
referencing new row as n
for each row
insert into branch_cust 
  select n.branch_name, customer_name
  from depositor
  where depositor.account_number = n.account_number;
```

== 5.15

```sql
create function avg_salary(company_name varchar(20))
    returns real
    begin
        declare avg_sal real;
        select avf(salary)
        into avg_sal
        from works
        where works.company_name = company_name;
        return avg_sal;
    end;
  
select distinct company_name
from works
where avg_salary(company_name) > avg_salary('First Bank');
```

== 5.19

设s中删除的元组名为D，那么r中所有满足 B = D.A 的元组都会被删除，这就是级联删除。下面用一个trigger实现级联删除：
```sql
create trigger cascade_delete_r
after delete on s
referencing old row AS old
for each row
begin
    delete from r where B = old.A;
end;
```