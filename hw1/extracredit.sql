create view CoAuthor as (select a1.id as id1, a2.id as id2
		from Authored a1 inner join Authored a2 on a1.pubid = a2.pubid
		where not a1.id = a2.id);

create table SuciuNumber(
	id	int	not null unique,
	number	int,
	primary key(id)
);
insert into SuciuNumber (select id, 0
	from Author
	where name='Dan Suciu');

create function insertSuciuNumber() returns void as
$BODY$
declare 
    cnt int;
begin
    loop
    	cnt := (select count(*) from SuciuNumber);

    	insert into SuciuNumber (
		select distinct ca.id2, sn.number+1
		from CoAuthor ca inner join SuciuNumber sn on ca.id1 = sn.id
		where not exists(select * from SuciuNumber sn_ where sn_.id=ca.id2)
	);

	if (select count(*) from SuciuNumber) = cnt then
	    exit;
   	end if;
    end loop;
end;
$BODY$
LANGUAGE 'plpgsql';

select insertSuciuNumber();
select * from SuciuNumber;


drop function insertSuciuNumber();
drop table SuciuNumber;
drop view CoAuthor;
