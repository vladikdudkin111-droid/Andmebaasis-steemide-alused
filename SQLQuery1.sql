create database TARge25

--db valimine
use TARge25

--tabeli tegemine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (1, 'Female'),
(2, 'Male'),
(3, 'Unknown')

--tabeli sisu vaatamine
select * from Gender

--tehke tabel nimega Person
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'cat@cat.com', 1),
(6, 'Antman', 'ant@ant.com', 2),
(8, NULL, NULL, 2)

--sovime näha Person tabeli sisu
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_genderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sisestanud genderId alla väärtust
--siis see automaatselt sisestab sellele reale väärtuse 3 ehk Unknown
alter table Person 
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email, GenderId)
values (7, 'Flash','f@f.com',NULL)

insert into Person (Id, Name, Email)
values (9, 'Black Panther','p@p.com')

select * from Person

--kustutada DF_Persons_GenderId piirang koodiga
alter table Person
drop constraint DF_Persons_GenderId

--lisame koodiga veeru
alter table Person
add Age int

--lisame piirangu vanuse sisestamisel
alter table Person
add constraint CK_Person_Age check(Age > 0 and Age < 155)

--kui sa tead veergude järjekorda peast
--siis ei pea neid sisestama
insert into Person
values(10, 'Green Arrow', 'g@g.com', 2, 54)

--constrainti kustutamine
alter table Person
drop constraint CK_Person_Age

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 130)

--kustutame rea
delete from Person where Id = 10

--kuidas uuendada andmeid koodiga
--Id 3 uus vanus on 50
update Person
set Age = 50
where Id =3

--lisame Person tabelisse City
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'

--kõik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'
select * from Person where City != 'Gotham'
select * from Person where not City = 'Gotham'

--näitab teatud vanusega inimesi
select * from Person where Age = 35 or Age = 42 or Age = 23
select * from Person where Age in (35, 42, 23)

--näitab teatud vanusevahemikus olevaid isikuid
select * from Person where Age between 22 and 39

--wildcardi kasutamine
--näitab kõik g-tähega linnad
select * from Person where City like 'g%'

--email, kus on @ märk
select * from Person where Email like '%@%'

--emaili muster
select * from Person where Email like '_@_.com'

--kõik, kellel on nimes esimene täht W, A, S
select * from Person where Name like '[WAS]%'
select * from Person where Name like '[^WAS]%'

--kes elavad Gothamis ja New Yorkis
select * from Person where City = 'Gotham' or City = 'New York'

--kes elavad Gothamis ja New Yorkis ja on vanemad kui 29
select * from Person 
where (City = 'Gotham' or City = 'New York')
and Age >= 30

--kuvab tähestikulises järjekorras inimesi
select * from Person order by Name

--kuvab vastupidises järjestuses
select * from Person order by Name desc

--võtab kolm esimest rida
select top 3 * from Person

--näita esimesed 50% tabelist
select top 50 percent * from Person

--kõikide isikute koondvanus
select sum(Age) from Person

--näitab kõige nooremat isikut
select min(Age) from Person

--kõige vanem isik
select max(Age) from Person

--näeme linnade kaupa vanuse summat
select City, sum(Age) as TotalAge
from Person
group by City

select City, GenderId, sum(Age) as TotalAge
from Person
group by City, GenderId
order by City

--näitab mitu rida on tabelis
select count(*) from Person

--näitab mitu inimest on igas linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total Person(s)]
from Person
where GenderId = 2
group by GenderId, City

--having näide
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total Person(s)]
from Person 
group by GenderId, City
having sum(Age) > 41

--kustutame tabelid kui need juba eksisteerivad
drop table if exists Employees
drop table if exists Department

--loome tabeli Department
CREATE TABLE Department (
    Id INT PRIMARY KEY,
    DepartmentName NVARCHAR(50),
    Location NVARCHAR(50),
    DepartmentHead NVARCHAR(50)
);

--loome tabeli Employees
CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10),
    Salary INT,
    City NVARCHAR(50),
    DepartmentId INT
);

--andmete sisestamine Employees tabelisse
INSERT INTO Employees (Id, Name, Gender, Salary, City, DepartmentId)
VALUES
(1, 'Tom', 'Male', 4000, 'London', 1),
(2, 'Pam', 'Female', 3000, 'New York', 3),
(3, 'John', 'Male', 3500, 'London', 1),
(4, 'Sam', 'Male', 4500, 'London', 1),
(5, 'Todd', 'Male', 2800, 'Sydney', 4),
(6, 'Ben', 'Male', 7000, 'New York', 3),
(7, 'Sara', 'Female', 4800, 'Sydney', 4),
(8, 'Valarie', 'Female', 5500, 'New York', 3),
(9, 'James', 'Male', 6500, 'London', 1),
(10, 'Russell', 'Male', 8800, 'London', 1);

--andmete sisestamine Department tabelisse
insert into Department(Id, DepartmentName, Location, DepartmentHead)
values
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella');

--JOIN päring
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id;

--arvutame kõikide palgad kokku
select sum(cast(Salary as int)) from Employees
--min palga saaja
select min(cast(Salary as int)) from Employees

---rida 251
---4 tund
---