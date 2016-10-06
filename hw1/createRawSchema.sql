drop table Pub;
drop table Field;
create table Pub (k text, p text);
create table Field (k text, i text, p text, v text);
copy Pub from '/home/ubuntu/uw/cse544/hw1/pubFile.txt';
copy Field from '/home/ubuntu/uw/cse544/hw1/fieldFile.txt';
