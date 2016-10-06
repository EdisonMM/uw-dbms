-- 1

/*
create table Author(
	id	int	not null unique,
	name	text,
	homepage	text,
	primary key (id)
);
create table Publication(
	pubid	int	not null unique,
	pubkey 	text	not null unique,
	title	text,
	year	text,
	primary key (pubid)
);
create table Article(
	pubid	int	not null unique,
	journal	text,
	month	text,
	volume	text,
	number	text,
	primary key (pubid),
	foreign key (pubid) references Publication(pubid)
);
create table Book(
	pubid	int	not null unique,
	publisher	text,
	isbn	text,
	primary key (pubid),
	foreign key (pubid) references Publication(pubid)
);
create table Incollection(
	pubid	int	not null unique,
	booktitle	text,
	publisher	text,
	isbn	text,
	primary key (pubid),
	foreign key (pubid) references Publication(pubid)
);
create table Inproceedings(
	pubid	int	not null unique,
	booktitle	text,
	editor	text,
	primary key (pubid),
	foreign key (pubid) references Publication(pubid)
);
create table Authored(
	id	int	not null,
	pubid	int	not null,
	foreign key (id) references Author(id),
	foreign key (pubid) references Publication(pubid)
);
drop table Authored;
drop table Inproceedings;
drop table Incollection;
drop table Book;
drop table Article;
drop table Publication;
drop table Author;
*/

-- 2

/*
create table tmpAuthor(
	k text not null,
	v text
);
create table tmpTitle(
	k text not null unique,
	v text,
	primary key (k) --, foreign key (k) references Field(k)
);
create table tmpYear(
	k text not null unique,
	v text,
	primary key (k) --, foreign key (k) references Field(f)
);
create table tmpJournal(
	k text not null unique,
	v text,
	primary key(k) --, foreign key (k) references Field(k)
);
create table tmpPublisher(
	k text not null unique,
	v text,
	primary key(k) --, foreign key (k) references Field(k)
);
create table tmpMonth(
	k text not null unique,
	v text,
	primary key(k) --, foreign key (k) references Field(f)
);
create table tmpVolume(
	k text not null unique,
	v text,
	primary key (k) --, foreign key (k) references Field(f)
);
create table tmpNumber(
	k text not null unique,
	v text,
	primary key (k) --, foreign key (k) references Field(f)
);
create table tmpIsbn(
	k text not null unique,
	v text,
	primary key(k) --, foreign key (k) references Field(k)
);
create table tmpBooktitle(
	k text not null unique,
	v text,
	primary key(k) --, foreign key (k) references Field(k)
);
create table tmpEditor(
	k text,
	v text
);

insert into tmpAuthor (select k, v from Field where p = 'author');
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'title')
insert into tmpTitle (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'year')
insert into tmpYear (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'journal')
insert into tmpJournal (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'publisher')
insert into tmpPublisher (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'month')
insert into tmpMonth (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'volume')
insert into tmpVolume (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'number')
insert into tmpNumber (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'isbn')
insert into tmpIsbn (select k, v from tmp where r = 1);
with tmp as (select row_number() over (partition by k) as r, k, v
		from Field where p = 'booktitle')
insert into tmpBooktitle (select k, v from tmp where r = 1);
insert into tmpEditor (select f.k, f.v from Field f where f.p = 'editor');
*/

/*
create index PubKey on Pub(k);
create index FieldKey on Field(k);
create index PubP on Pub(p);
create index FieldP on Field(p);
create index FieldV on Field(v);

-- q1. for each type of publication, count the total number of publications of that type.

select p, count(*) from Pub group by p;

-- q2. We say that a field "occurs" in a publication type, if there exists at least one publication of that type having that field. For example, "publisher occurs in incollection", but "publisher does not occur in inproceedings" (because no inproceedings entry with a publisher). Find the fields that occur in all publications types. Your query should return a set of field names.


with Occurs as (select distinct p.p as pubtype, f.p as field
		from Pub p inner join Field f
		on p.k = f.k)
select distinct o.field
from Occurs o
where exists (select * from Occurs o1
		where o.field = o1.field and o1.pubtype = 'article')
	and exists (select * from Occurs o1
		where o.field = o1.field and o1.pubtype = 'book')
	and exists (select * from Occurs o1
		where o.field = o1.field and o1.pubtype = 'incollection')
	and exists (select * from Occurs o1
		where o.field = o1.field and o1.pubtype='inproceedings');
*/
-- 3.

/*
create sequence authorSeq;
create sequence pubSeq;
create table Homepage(name text not null unique, homepage text);

with tmp as (select row_number() over (partition by ta.v) as r, ta.v as name, f2.v as hp
	from tmpAuthor ta inner join Field f1 on ta.k=f1.k
		inner join Field f2 on ta.k=f2.k
	where f1.p='title' and f1.v='Home Page' and f2.p='url')
insert into Homepage (select name, hp from tmp where r = 1);

insert into Author(select nextval('authorSeq'), a.v, h.homepage
	from tmpAuthor a left outer join Homepage h on a.v=h.name);

insert into Publication (select nextval('pubSeq'), tt.k, tt.v, ty.v
	from tmpTitle tt left outer join tmpYear ty on tt.k = ty.k
		inner join Pub p on tt.k = p.k
	where p.p = 'article' or p.p = 'book' or p.p = 'incollection' or p.p = 'inproceedings');


drop table Homepage;
drop sequence authorSeq;
drop sequence pubSeq;
insert into Article(select p.pubid, tj.v, tm.v, tv.v, tn.v
		from Publication p
			left outer join tmpJournal tj on p.pubkey = tj.k
			left outer join tmpMonth tm on p.pubkey = tm.k
			left outer join tmpVolume tv on p.pubkey = tv.k
			left outer join tmpNumber tn on p.pubkey = tn.k
		where exists (select * from pub pb
			where pb.k = p.pubkey and pb.p = 'article'));
insert into Book(select p.pubid, tp.v, ti.v
		from Publication p
			left outer join tmpPublisher tp on p.pubkey = tp.k
			left outer join tmpIsbn ti on p.pubkey = ti.k
		where exists (select * from pub pb
			where pb.k = p.pubkey and pb.p = 'book'));
insert into Incollection(select p.pubid, tb.v, tp.v, ti.v
		from Publication p
			left outer join tmpBooktitle tb on p.pubkey = tb.k
			left outer join tmpPublisher tp on p.pubkey = tp.k
			left outer join tmpIsbn ti on p.pubkey = ti.k
		where exists (select * from pub pb
			where pb.k = p.pubkey and pb.p = 'incollection'));
*/

select p.pubid, tb.v, te.v
	from Publication p
		left outer join tmpBooktitle tb on p.pubkey = tb.k
		left outer join tmpEditor te on p.pubkey = te.k
	where p.pubid='784441' and exists (select * from pub pb
		where pb.k = p.pubkey and pb.p = 'inproceedings');



insert into Inproceedings(select p.pubid, tb.v, te.v
		from Publication p
			left outer join tmpBooktitle tb on p.pubkey = tb.k
			left outer join tmpEditor te on p.pubkey = te.k
		where exists (select * from pub pb
			where pb.k = p.pubkey and pb.p = 'inproceedings'));


/*
insert into Authored(select a.id, p.pubid
		from tmpAuthor ta inner join Author a on ta.v = a.name
			inner join Publication p on ta.k = p.pubkey);
*/

-- TODO : HERE

/*
drop table tmpAuthor;
drop table tmpTitle;
drop table tmpYear;
drop table tmpJournal;
drop table tmpPublisher;
drop table tmpMonth;
drop table tmpVolume;
drop table tmpNumber;
drop table tmpIsbn;
drop table tmpBooktitle;
drop table tmpEditor;
*/

-- 4.
/*
--q1. Find the top 20 authors with the largest number of publications. Runtime: under 10s.

select a.name, count(*) as pubNum
from Author a inner join Authored aed on a.id = aed.id
group by a.name order by pubNum desc limit 20;

-- q2. Find the top 20 authors with the largest number of publications in STOC. Repeat this for two more conferences, of your choice (suggestions: top 20 authors in SOSP, or CHI, or SIGMOD, or SIGGRAPH; note that you need to do some digging to find out how DBLP spells the name of your conference). Runtime: under 10s.

create view PubPublisher as (
	select pubid, publisher from Book
 	union select pubid, publisher from Incollection);

create view AuthorPublisher as (
	select au.id as id, pp.publisher as publisher
	from Authored au inner join PubPublisher pp on au.pubid = pp.pubid);

with topAuthor as (select id, count(*) as num
		from AuthorPublisher
		where publisher	= 'STOC')
select a.name
from topAuthor ta inner join Author a on ta.id = a.id
order by ta.num limit 20;

-- q3. The two major database conferences are 'PODS' (theory) and 'SIGMOD Conference' (systems). Find (a) all authors who published at least 10 SIGMOD papers but never published a PODS paper, and (b) all authors who published at least 5 PODS papers but never published a SIGMOD paper. Runtime: under 10s.

with NSIG as (select id, count(*) as ns
		from AuthorPublisher where publisher='SIGMOD')
     NPOD as (select id, count(*) as np
		from AuthorPublisher where pp.publisher='PODS')
create view AuthorDB as (select NSIG.id as id, NSIG.ns as ns, NPOD.np as np
		from NSIG inner join NPOD on NSIG.id = NPOD.id);
select a.name
from Author a inner join AuthorDB adb on a.id = adb.id
where adb.ns >= 10 and adb.np = 0;
select a.name
from Author a inner join AuthorDB adb on a.id = adb.id
where adb.ns = 0 and adb.np >= 5;

drop view PubPublisher;
drop view AuthorPublisher;
drop view AuthorDB;

-- q4. A decade is a sequence of ten consecutive years, e.g. 1982, 1983, ..., 1991. For each decade, compute the total number of publications in DBLP in that decade. Hint: for this and the next query you may want to compute a temporary table with all distinct years. Runtime: under 1minute. Note: we are looking for ANY period of ten consecutive years, not just those that start and end with 0's. 

create table numPubYear(
	year int not null unique, 
	num int
);
insert into numPubYear (select convert(int, year), count(*)
			from Publication
			group by year);

select * from numPubYear;

select y.year, sum(*)
from numPubYear y, numPubYear z
where z.year >= y.year and z.year < y.year+10
group by y.year
order by y.year;
drop table numPubYear;

-- q5. Find the top 20 most collaborative authors. That is, for each author determine its number of collaborators, then find the top 20. Hint: for this and some question below you may want to compute a temporary table of coauthors. Runtime: a couple of minutes.

with CoAuthor as (select a1.id as id1, a2.id as id2
		from Authored a1 inner join Authored a2 on a1.pubid = a2.pubid)
	CollaboNum as (select id as id, count(*) as num
		from CoAuthor
		group by id)
select a.name
from CollaboNum co inner join Author a on co.id = a.id
order by co.num limit 20;


-- q6. Extra credit: For each decade, find the most prolific author in that decade. Hint: you may want to first compute a temporary table, storing for each decade and each author the number of publications of that author in that decade. Runtime: a few minutes.

create table numAuYear(
	year int not null unique,
	id text,
	num int
);
insert into numAuYear (select cast(int, p.year), au.id, count(*)
		from Publication p inner join Authored au on p.pubid = au.pubid
		group by p.year, au.id);
create table numAuDec(
	year int not null unique,
	id text,
	num int
);
insert into numAuDec (select x.year as year, x.id as id, sum(y.num) as tot
		from numAuDec x inner join numAuDec y on x.id = y.id
		where y.year >= x.year and y.year<x.year+10);
select nad.year, a.name
from numAuDec nad inner join Author a on nad.id = a.id
where nad.year, nad.tot in (select year, max(tot)
			from numAuDec
			group by year);

-- q7. Extra credit: Find the institutions that have published most papers in STOC; return the top 20 institutions. Then repeat this query with your favorite conference (SOSP or CHI, or ...), and see which are the best places and you didn't know about. Hint: where do you get information about institutions? Use the Homepage information: convert a Homepage like http://www.cs.washington.edu/homes/levy/ to http://www.cs.washington.edu, or even to www.cs.washington.edu: now you have grouped all authors from our department, and we use this URL as surrogate for the institution. Google for substring, position and trim in postgres.

create table Num(n int);
insert into Num values(1);
insert into Num(values(2));
insert into Num(values(3));

create table Inst(id text, inst text);
insert into Inst(
	with Url as (select a.id as id, split_part(a.homepage, '/', n.n) as url
		from Author a, Num n)
	select id, url
	from (select ROW_NUMBER() over (partition by id) as r, id, url
		from Url
		where not url='' and not url='http:' and not url='https:') as rs
	where r=1);

with TopInst(select i.inst as inst, count(*) as num
	from Inst i inner join AuthorPublisher ap on i.id = ap.id
	group by i.inst)
select inst
from TopInst
order by num desc limit 20;

drop table Num;
drop table Inst;
drop view AuthorPublisher;
drop view PubPublisher;

--5
*/

