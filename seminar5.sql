create database seminar5223bd2022;
go
use seminar5223bd2022;
go

create table EchipeCampionatMondial(
	cod_c int not null,
	nume varchar(100),
	antrenor varchar(100),
	nr_victorii int,
	nr_egaluri int,
	nr_infrangeri int
);

insert into EchipeCampionatMondial(cod_c, nume, antrenor, nr_victorii, nr_egaluri, nr_infrangeri) 
values 
(1, 'Portugalia', 'Santos', 5, 1, 1),
(-20, 'Anglia', 'Southgate', 4, 2, 0),
(3, 'Spania', 'Luis', 3, 0, 2),
(100, 'Brazilia','Tite', 3, 1, 1)

select * from EchipeCampionatMondial;
select * from EchipeCampionatMondial where nr_victorii = 3;

go
alter table EchipeCampionatMondial 
add constraint pk_EchipeCampionatMondial primary key (cod_c);

select * from EchipeCampionatMondial where cod_c = 2;

insert into	EchipeCampionatMondial (cod_c, nume, antrenor, nr_victorii, nr_egaluri, nr_infrangeri)
values (-5, 'Germania', 'Flick', 4, 1, 2);

create nonclustered index IX_EchipeCampionatMondial_Victorii_desc on EchipeCampionatMondial (nr_victorii desc);

select nr_victorii from EchipeCampionatMondial where nr_victorii < 3;

create unique nonclustered index IX_EchipeCampionatMondial_nume_uq_asc ON EchipeCampionatMondial (nume asc);
select nume from EchipeCampionatMondial;

delete from EchipeCampionatMondial where cod_c = 34;

insert into EchipeCampionatMondial(cod_c, nume, antrenor, nr_victorii, nr_egaluri, nr_infrangeri) 
values (34, 'Echipa de test', 'antrenor de test', 1, 2, 2),
(-52, 'Germania', 'Flick', 4, 1, 2),
(35, 'Echipa de test1', 'antrenor de test1', 2, 2, 2);

drop index IX_EchipeCampionatMondial_nume_uq_asc ON EchipeCampionatMondial;

create unique nonclustered index IX_EchipeCampionatMondial_nume_uq_asc ON EchipeCampionatMondial (nume asc) with (ignore_dup_key = on);

select nume from EchipeCampionatMondial order by nume asc;
select nume from EchipeCampionatMondial order by nume desc;

use [Parc_Distractii]
go

insert into categorii(nume) values ('pensionari'), ('copii'), ('elevi'), ('pensionari');
select nume from categorii where nume = 'pensionari' or nume = 'copii';
create nonclustered index IX_Categorii_Nume_asc on categorii(nume asc);
select * from categorii where nume = 'pensionari' or nume = 'copii';

insert into sectiuni(nume, descriere) values ('s1', 'atractie'), ('c2', 'atractie'), ('s3', 'atractie');
select nume from sectiuni where nume like 'c%';
create nonclustered index IX_Sectiuni_Nume_asc on sectiuni(nume asc);