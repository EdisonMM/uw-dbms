--select * from Pub limit 5;
--select * from Field limit 5;

--select distinct p.k, f.k, p.p, f.p from Pub p inner join Field f on p.k = f.k;

/*drop table R;
drop table S;
drop table T;

create table R(a text, b int);
insert into R values ('a', 1);
insert into R values ('b', 3);
insert into R values ('c', 4);

create table S(b int, c text);
insert into S values(3, 'A');
insert into S values(5, 'AA');

create table T(b int, d int);
insert into T values(3, 1);
insert into T values(1, 7);
insert into T values(8, 8);

--select * from R inner join S on R.b = S.b;
--select * from R left outer join S on R.b = S.b;

select * from R left outer join T on R.b = T.b;

select *
from R left outer join S on R.b = S.b
left outer join T on R.b = T.b;*/


/*
select * from tmpPublisher
where (v = 'STOC' or v = 'ACM Symposium on Theory of computing' or  
v = 'symposium on Theory of Computing');
*/

create view STOC as select * from tmpBooktitle where v like '%STOC%' or v like '%symposium of theory of computing%';
create view SIGMOD as select * from tmpBooktitle where v like '%SIGMOD%' or v like '%special interest group on management of data%';
create view PODS as select * from tmpBooktitle where v like '%PODS%';

select * from Field
where (v like '%STOC%' or v like '%ymposium of theory of computing%')
	and not (p='booktitle' or p='note' or p='url' or p='title')
	and k not in (select k from STOC);
select * from Field
where (v like '%SIGMOD%' or v like '%special interest group on management of data%')
	and not (p='booktitle' or p='note' or p='url' or p='title')
	and k not in (select k from SIGMOD);

select * from Field
where (v = '%PODS%' and not p='booktitle')
	and k not in (select k from PODS);

drop view STOC; drop view SIGMOD; drop view PODS;

-- q2. Find the top 20 authors with the largest number of publications in STOC. Repeat this for two more conferences, of your choice (suggestions: top 20 authors in SOSP, or CHI, or SIGMOD, or SIGGRAPH; note that you need to do some digging to find out how DBLP spells the name of your conference). Runtime: under 10s.

-- q3. The two major database conferences are 'PODS' (theory) and 'SIGMOD Conference' (systems). Find (a) all authors who published at least 10 SIGMOD papers but never published a PODS paper, and (b) all authors who published at least 5 PODS papers but never published a SIGMOD paper. Runtime: under 10s.
















