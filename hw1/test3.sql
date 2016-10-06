create table Author(id text, homepage text);
insert into Author values('1', 'http://www.cs.washington.edu/home/~lee/');
insert into Author values('2', 'https://www.cse.snu.ac.kr/kim/');
insert into Author values('3', 'http://www.cs.washington.edu/home/pub/');
insert into Author values('4', 'http://www.cse.snu.ac.kr/james/lee');
insert into Author values('5', 'http://www.cs.washington.edu/home/~lee/');
insert into Author values('6', 'https://www.kaist.ac.kr/sewonmin');
insert into Author values('6', 'httpt://github.com/shmsw25');
insert into Author values('7', null);

create table Num(n int);
insert into Num values(1);
insert into Num(values(2));
insert into Num(values(3));

select * from Author;

create table Inst(id text, inst text);
insert into Inst(
	with Url as (select a.id as id, split_part(a.homepage, '/', n.n) as url
		from Author a, Num n)
	select id, url
	from (select ROW_NUMBER() over (partition by id) as r, id, url
		from Url
		where not url='' and not url='http:' and not url='https:') as rs
	where r=1);

select * from Inst;
drop table Author; drop table Num; drop table Inst;
