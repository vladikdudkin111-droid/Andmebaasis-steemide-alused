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
---17.2´03.26
---teeme left join päringu
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department 
on Employees.DepartmentId = Department.Id
group by Location --ühe kuu palgafound linnade lõikes

--teem veeru nimega City Employees tabelisse
--nvarchar 30
alter table Employees
add City nvarchar(30)

select * from Employees

--peale selecti tulevad veergude nimed
select City, Gender, sum(cast(Salary as int)) as TotalSalary
--tabelist nimega Employees ja mis on grupitatud City ja Gende järgi
from Employees group by City, Gender

--oleks vaja, et linnad oleksid tähestikulises järjekorras
select City, Gender, sum(cast(Salary as int)) as TotalSalary
from Employees group by City, Gender
order by City
--order by järjestab linnad tähesitkuliselt,
--aga kui on nullid, siis need tulevad kõige ette

--loeb ära, mitu rida on tabelis Employees
-- * asemel võib panna ka veeru nime,
-- aga siis loeb ainult selle veeru väärtused, mis ei ole nullid
select COUNT(*) from Employees

--mitu töötajat on soo ja linna kaupa
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees
group by City, Gender

--kuuvab ainult kõik mehed linnade kaupa
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees
where Gender = 'Female'
group by City, Gender

--sama tulemuse, aga kasutage having klauslit
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count(Id) as [Total Employee(s)]
from Employees
group by City, Gender
having Gender = 'Male'

--näitab meile ainult need töötajad, kellel on palga summa üle 4000
select * from Employees
where sum(cast(Salary as int)) > 4000

select City, sum(cast(Salary as int)) as TotalSalary, Name,
count(Id) as [Total Employee(s)]
from Employees
group by Salary, City, Name
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1) primary key,
Value nvarchar(30)
)

insert into Test1 values('x')
select * from Test1

--kustutame veeru nimega City Employees tabelist
alter table Employees
drop column City

--inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
select Name, Gender, SAlary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left joine
--kuvab kõik read Employees tabelist,
-- aga Departmentname näitab ainult siis, kui on olemas
--kui DepartmentId on null, siis DepartmentName näitab nulli
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--right jpin
--
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

--right join
--kuvab kõik read Department tabelist
--aga Name näitab ainult siis, kui on olemas väärtus DepartmentId-s, mis on sama
--Department, tabeli ID-ga
select Name, GEnder, Salary, DEpartmentName
from Employees
right join Department
on Employees.DepartmentID = Department.Id

-- full outer join ja full join on sama asi
--kuvab kõik read mõlemast tabelist,
--aga kui ei ole vastet, siis näitab nulli
select Name, GEnder, Salary, DEpartmentName
from Employees
full join Department
on Employees.DepartmentID = Department.Id

--cross join
--kuvab kõik read mõlemast tabelist, aga ei võta aluseks mingit veergu,
--vaid lihtsalt kombineerib kõik read omavahel
--kasutatakse harva, aga kui on vaja kombineerida
select Name, GEnder, Salary, DepartmentName
from Employees

--päringu sisu
select ColumnList
from LeftTable
joinType RightTable
on JoinCondition

select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Department.Id = Employees.DepartmentId

--kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.id is null

--kuidas saame department tabelis oleva rea, kus on NULL
select Name, GEnder, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--full join
--kus on vaja kuvada kõik read mõlemast tabelist,
--millel ei ole vastet
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

--tabeli nimetuse muutmine koodiga
sp_rename 'Employees', 'Employees'

--kasutame Employees tabeli asemel lühendit E ja M
--aga enne seda lisame uue veeru nimega ManagerId ja see on int
alter table Employees
add ManagerId int

--antud juhul E on Employees tabeli lühend ja M
--on samuti Employees tabeli lühend, aga me kasutame
--seda, et näidata, et see on manageri tabel
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--ineer join ja kasutame lühendeid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--cross join ja kasutame lühendeid
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select FirstName, LAstName, Phone, AdressID, AddressType
from SalesLt.CustomerAddress
left join salesLT.Customer
on SalesLT.CustomerAddress.CustomerID = SalesLT.Customer.CustomerID

