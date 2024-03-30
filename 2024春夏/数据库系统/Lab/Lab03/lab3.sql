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

insert student values('1001', 'Wang', 'M', 20, 'CS');
insert student values('1002', 'Li', 'F', 19, 'CS');
insert student values('1003', 'Zhang', 'M', 21, 'EE');
insert student values('1004', 'Zhao', 'F', 22, 'CS');

insert student values('1001', 'Ping', 'F', 22, 'CE');

insert enroll value('1001', 'C1', 90);

delete from student where sname = 'Wang';

update student set sid = '1005' where sname = 'wang';

insert student values('1005', 'Wang', 'M', -20, 'CS');

create assertion check_age check (not exists (select * from student where sage >= 50 and sage <= 100));

Delimiter $$
Create trigger age_present
After update on student
For each row -- 这句话在MySQL中是固定的
Begin
	Update enroll set grade =100
where enroll.id in (select id from students where age<15);
end; $$
Delimiter ;
