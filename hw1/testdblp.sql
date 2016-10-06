--drop view STOC; drop view SIGMOD; drop view PODS;
--drop table tmpBooktitle;
--select * from tmpMonth;

/*
select ta.v, f2.v
from tmpAuthor ta inner join Field f1 on ta.k=f1.k
	inner join Field f2 on ta.k=f2.k
where ta.v='Stephen S. Intille' and f1.p='title' and f1.v='Home Page' and f2.p='url';

*/

select count(*) from Article;
select count(*) from Book;
select count(*) from Incollection;
select count(*) from Inproceedings;
select count(*) from Authored;






