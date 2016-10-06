create table A(
	a int
);
create table B(
	a int,
	b text
);
create table C(
	a int,
	c text
);
insert into A values(1);
insert into A values(2);
insert into A values(3);
insert into A values(4);
insert into A values(5);
insert into B values(1, 'A');
insert into B values(1, 'AA');
insert into B values(2, 'B');
insert into B values(3, 'C');
insert into B values(3, 'CC');
insert into C values(1, 'App');
insert into C values(1, 'Apple');
insert into C values(1, 'Appplee');
insert into C values(2, 'Bpp');
insert into C values(5, 'Canada');

select * from A;
select * from B;
select * from C;
/*
select NB.a, NB.nb, NC.nc
from (select A.a as a, count(B.b) as nb
	from A left outer join B on A.a=B.a group by A.a) as NB
inner join (select A.a as a, count(C.c) as nc
	from A left outer join C on A.a=C.a group by A.a) as NC
on NB.a = NC.a;
*/






drop table A; drop table B; drop table C;
