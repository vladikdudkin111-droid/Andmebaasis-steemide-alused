create database TARge25

--db valimine (use Master v�i use TARge25, et valida DB)
use TARge25

--db kustutamine
drop database TARge25

--table tegemine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male'),
(1, 'Female'),
(3, 'Unknown')

--tabeli sisu vaatamine
select * from Gender

--tehke tabel nimega Person
--id int, not null, primary key
--Name nvarchar 30
--Email nvarchar 30
--GenderId Int
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderID int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderID)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'cat@cat.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--soovime n�ha Person tabeli sisu
select * from Person

--v��rv�tme �henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderID) references Gender(Id)

--kui sisestada uue rea andmeid ja ei ole sisestanud genderID alla v��rtust, siis
--see automaatselt sisestab sellele reale v��rtuse 3 e mis on meil unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email, GenderID)
values(7, 'Flash', 'f@f.com', NULL)

insert into Person (Id, Name, Email)
values(9, 'Black Panther', 'p@p.com')

select * from Person

--kustutada DF_Persons_GenderId piirang koodiga
alter table Person
drop constraint DF_Persons_GenderId

--lisame koodiga veeru
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse sisestamisel (add lisab alter muudab)
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kui tead veergude j�rjekorda peast, siis ei pea neid sisestama
insert into Person
values (10, 'Green Arrow', 'g@g.com', 2, 154)

--constrainti kustutamine
alter table Person
drop constraint CK_Person_Age

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 130)

--kustutame rea
delete from person where Id = 10

--kuidas uuendada andmeid koodiga
--Id 3 uus vanus on 50
update Person
set Age = 50
where Id = 3

--lisame Person tabelisse veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

--k�ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--k�ik, kes ei ela Gothamis (!= v�i <> v�i NOT (kus) = (mis)
select * from Person where NOT City = 'Gotham'
select * from Person where City != 'Gotham'
select * from Person where City <> 'Gotham'

--n�itab teatud vanusega inimesi
--35, 42, 23
select * from Person where Age = 35 or Age = 42 or Age = 23
select * from Person where Age in (35, 42, 23)

--n�itab teatud vanusevahemikus olevaid isikuid 22 kuni 39
select * from Person where Age > 22 and Age < 39
select * from Person where Age between 22 and 39

--wildcardi kasutamine
--n�itab k�ik g-t�hega algavad linnad
select * from Person where City like 'g%'

--n�itab k�ik g t�hte sisaldavad linnad
select * from Person where City like '%g%' -- * valib k�ik (v�ib asendada veeru valikuga, mida n�idata)
--email, kus on @ m�rk sees
select * from Person where Email like '%@%'

--n�itab, kellel on emailis ees ja peale @-m�rki ainult �ks t�ht ja omakorda .com
select * from Person where Email like '_@_.com'

--k�ik, kellel on nimes esimene t�ht w,a,s
--katusega ^ v�listab t�hed
select * from Person where Name like '[was]%'
select * from Person where Name like '[^was]%'

--kes elavad Gothamis ja New Yorkis (sulud on visuaalne)
select * from Person Where (city = 'Gotham' or City = 'New York')

--kes elavad Gothamis ja New Yorkis ja on vanemad, kui 29
select * from Person Where (city = 'Gotham' or City = 'New York') and Age > 29

--rida 142
-- 3 tund
-- 10.03.2026

-- kuvab t�hestikulises j�rjekorras inimesi ja v�tab aluseks nime
select * from Person order by Name
--kuvab tagurpidi
select * from Person order by Name DESC

--v�tab kolm esimest rida person tabelist
select top 3 * from Person

--kolm esimest, aga tabeli j�rjestus on Age ja siis Name
select * from Person
select top 3 Age, Name from Person order by cast(Age as INT) --cast abil teeme Age INT muidu oli varchar

--n�ita esimesed 50% tabelist
select top 50 percent * from Person

--k�ikide isikute koondvanus
select sum(cast(Age as INT)) from Person

--n�itab k�ige nooremat isikut
select min(cast(Age as Int)) from Person

--muudame Age veeru int andmet��biks
alter table Person alter column Age int;

--n�eme konkteetses linnades olevate isikute koondvanust
select sum(Age) from Person where City like 'Gotham' -- leiab �he linna kohta
select City, sum(Age) as TotalAge from Person group by City -- arvutab k�ik linnad

-- kuvab 1. reas v�lja toodud j�restuses ja kuvab Age TotalAge'ks
-- J�rjestab City's olevate nimede j�rgi ja siis GenderID j�rgi
select City, GenderID, sum(Age) as TotalAge from Person group by city, GenderID order by City

--n�itab, et mitu rida on selles tabelis
select * from Person
select count(*) from Person

--n�itab tulemust, et mitu inimest on GenderId v��rtusega 2 konkreetses linnas
--arvutab vanuse kokku konkteetses linnas
select GenderID, City, sum(Age) As TotalAge, count(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderID, City

--n�itab �ra inimeste koondvanuse linnas, mis on �le 41 a ja kui palju neid igas linnas elab
--eristab soo j�rgi
select GenderID, City, sum(Age) As TotalAge, Count(Id) as [Total Person(s)]
from Person
-- where Age > 41 -- sellega arvutaks isikud kelle vanus �ksi on �le 41
group by GenderID, City having sum(age) > 41 -- having... osa v�tab koond vanus �le 41

--loome tabelid Employees ja Department
create table Department
(
Id int not null primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int not null primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentID int
)

--andmete sisestamine
insert into Employees (Id, Name, Gender, Salary, DepartmentID)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800,2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russel', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values (1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cinderella')

alter table Employees add constraint tblEmployees_DepartmentID_FK
foreign key (DepartmentID) references Department(Id)

--
select name, Gender, Salary, DepartmentName from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutame k�ikide palgad kokku -- muudame INT'iks cast abil cast(... as int)
select sum(cast(Salary as int)) as SumSalary from Employees
--min palga saja
select min(cast(Salary as int)) MinSalary from Employees

--- Rida 251
--- 4 tund
--- 17.03.26
--- teeme left join p�ringu
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentID = Department.Id
group by Location --�he kuu palgafond linnade l�ikes

-- Teeme veeru nimega City Employees tabelisse
--nvarchar 30
alter table Employees
add City nvarchar(30)

select * from Employees

-- peale selecti tuleb veergude nimed
select City, Gender, sum(cast(Salary as int)) as TotalSalary
--tabelist Employees ja mis on grupitatud City ja Gender j�rgi
from Employees group by City, Gender
--oleks vaja, et linnad oleksid t�hestukulises j�rjekorras
order by City --- order by j�rjestab linnad t�hestikuliselt, kui on NULLID siis need tulevad k�ige ette

select count(*) from Employees --loeb mitu rida on tabelis Employees
-- * asemel v�ob panna ka veeru nime, aga siis loeb ainult selle veeru v��rtusi, mis ei ole NULL'id

-- mitu t��tajat on soo ja linna kaupa
select Gender, City, sum(cast(Salary as int)) as TotalSalary, count(*) as 'Total Employee(s)'
from Employees group by Gender, City

--Kuvab ainult k�ik mehed linnade kaupa
select Gender, City, sum(cast(Salary as int)) as TotalSalary, count(*) as 'Total Employee(s)'
from Employees where Gender = 'Male' group by Gender, City

--sama tulemus, aga kasutage having klauslit
select Gender, City, sum(cast(Salary as int)) as TotalSalary, count(*) as 'Total Employee(s)'
from Employees group by Gender, City having Gender = 'Male'

--n�itab meile ainult need t��tajad, kellel on palga summa �le 4000
select * from Employees where Salary > 4000

--havinguga, n�i�tab kus kui palju t��tajaid �le 4000 palgaga
select City, sum(cast(Salary as INT)) As [TotalSalary], Count(id) as [Total Empoyee(s)]
from Employees
Group by salary, City, Name
having sum(cast(Salary as INT)) > 4000

-- loome tabeli, milles hakatakse automaatselt nummberdama Id'd
create table Test1
(Id int identity(1, 1) primary key,
Value nvarchar(30)
)

insert into Test1 values('X')
select * from Test1

---kustutame veeru nimega City Employees tabelist
alter table Employees
drop column City

-- inner join
--kuvab neid, kellel on DepartmentName all olemas v��rtus
select name, Gender, Salary, DepartmentName
from Employees inner join Department
on Employees.DepartmentID = Department.Id

--left join
-- kuvab k�ik read Employees tabelist,
--aga DepartmentName n�itab ainult siis, kui on olemas
-- Kui DepartmentID on on NULL, siis Department Name n�itab NULL
select name, Gender, Salary, DepartmentName
from Employees
left join Department on Employees.DepartmentID = Department.Id

-- right join
-- kuvab Departmenti DepartmentName'id ning iga rea Employees tabelist,
-- millel on olemas sobiv DepartmentID, DepartmentNamed millele ei ole
-- vasteid t�idetakse NULL v��rtustega.
select name, Gender, Salary, DepartmentName
from Employees
right join Department on Employees.DepartmentID = Department.Id

--full outer join = full join
-- kuvab k�ik read (v��rtused) m�lemast tabelist, kui sobituv v��rtus puudub, kuvatakse NULL
select name, Gender, Salary, DepartmentName
from Employees
full join Department on Employees.DepartmentID = Department.Id

-- cross join
-- kuvab k�ik read m�lemast tabelist, aga ei v�ta aluseks mingit veergu
-- vaid lihtsalt kombineerib k�ik read omavahel
-- kasutatakse harva, aga kui on vaja kombineerida k�ik
-- v�imalikke komninatasioone kahe tabeli vahel, siis v�ib kasutada cross joini
select name, Gender, Salary, DepartmentName
from Employees
cross join Department

--p�ringu sisu (�ldine n�ide)---------------
select ColumnList
from LeftTable
joinType RightTable
on JoinCondition
--^^^^^^^^ JOIN �ldine n�ide ^^^^^^^^--

-- kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
full join Department -- saab ka left
on Department.Id = DepartmentId
where DepartmentName IS NULL
--variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Department.Id = DepartmentId
where DepartmentId is null
---variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Department.Id = DepartmentId
where Department.Id is null

--- kuidas saame department tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Department.Id = DepartmentId
where Employees.ID is null

-- full join
-- kus on vaja kuvada k�ik read m�lemast tabelist,
-- millel ei ole vastet.
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Department.Id = DepartmentId
where Employees.ID is null or Department.ID is null

--tabeli nimetuse muutmine koodiga
sp_rename 'Employees', 'Employees1'

-- kasutame Employees tabeli asemel, l�hedit E ja M
-- aga enne seda lisame uue veeru nimega ManagerID ja see on int
alter table Employees
add ManagerID int

-- antud juhl E on Employees tabeli l�hend ja M on samuti Employees tabeli l�hend,
-- aga me kasutame seda, et n�idata, et see on manageri tabel
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerID = M.Id

-- inner join ja kasutame l�hendeid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerID = M.Id

-- cross join ja kasutame l�hendeid
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

use AdventureWorksLT2019

--
select FirstName, LastName, Phone, AddressID, AddressType
from SalesLT.CustomerAddress
left join SalesLT.Customer
on SalesLT.CustomerAddress.CustomerID = SalesLT.Customer.CustomerID

--- Teha p�ring, kus kasutate ProductModelit ja Product, et n�ha,
--- millised tooted on millise mudeliga seotud
select PM.Name as ProductModel, P.Name as Product
from SalesLT.Product P
left join SalesLT.ProductModel PM
on PM.ProductModelID = P.ProductModelID

--harjutused JOIN, n�idiseks
-- rida 1: select [veerud, mida n�idata]
-- rida 2: from kust_tabelist_vask(left)_tabel
-- rida 3: join_meetod (left join, right join, inner join, cross join, full join millise_tabeliga_parem(right)_tabel
-- rida 4: on �hendus_tingimus (milliseid veerge kahe tabeli vahel v�rrelda)
-- rida 6: where tingimus (see rida kui t�psustada milliseid ridu n�idata)
select E.id, Name, Gender, Salary, D.DepartmentName, D.Location, D2.DepartmentHead
from Employees E
left join Department D
on E.DepartmentID = D.ID
left join Department D2 --teine tingimus, et liita n� kolmas tabel �hendusse
on E.ManagerID = D2.ID

-------------------- Erinevad joinid ---------------------
select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
left join Department D ---- n�itab k�ik vasakpoolse tabeli ridu, koos parempoolse v��rtusega, kui parempoolse vaste puudub, siis parempoolne on NULL
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
right join Department D ----- n�itab k�iki vaskpoolse ridu millel on parempoolse vaste, kui vaste puudub, siis vasteta parempoolsed read koos vaskpoolseosas NULL v��rtusega
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
inner join Department D ---- n�itab ridu millel on vasakul ja paremal v��rtused olemas (EI ole NULL v��rtusi) sama mis lihtsalt join
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
full join Department D --- n�itab molema poole k�ik read, k�ik millel on vaste ja millel pole vastet (null v��rtused)
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
cross join Department D --- ei kasuta on tingimust, �hendab tabelid andes iga parempoolse v�imaliku rea v��rtuse igale vasakpoolse tabeli reale

-------t�psustatud tingimustega-----------
select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
left join Department D
on E.DepartmentID = D.ID
where D.id is NULL -- left joiniga n�itab ainult left ridasid, millel seatud tingimus n�utud v��rtus

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
right join Department D
on E.DepartmentID = D.ID
where E.DepartmentID is NULL -- right joiniga n�itab ainult right ridasid, millel seatud tingimus n�utud v��rtus

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
full join Department D
on E.DepartmentID = D.ID
where E.departmentID is NULL or D.ID is NULL -- full joiniga n�itab lef and right ridu, millel seatud tingimus n�utud v��rtus (or abil saab mitu tingimust

-----self join, endaga �hendamine ----
select E.id, E.Name, E.Gender, E.Salary, M.Name as Manager
from Employees E
left join Employees M -- �hendame sama tabeli endaga andes l�hendite abil "uue" tabeli funktsiooni
on E.ManagerID = M.ID

select E.id, E.Name, E.Gender, E.Salary, M.Name as Manager
from Employees E
right join Employees M --- see j�tab v�lja isikud kellel ei ole manageri ning n�itab kes pole kellegi manager.
on E.ManagerID = M.ID

select E.id, E.Name, E.Gender, E.Salary, M.Name as Manager
from Employees E
full join Employees M --- n�itab nii left kui ka right join tulemust koos.
on E.ManagerID = M.ID

--rida 412
--4 tund
--31.03.26

--neil kellel ei ole ülemust, siis paneb neile No Manager teksti
select E. Name as Employee, isnull(M. Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E. ManagerId = M. Id
--kui Expression on õige, siis paneb väärtuse, mida soovid või
--vastasel juhul paneb No Manager teksti
case when Expression Then '' else '' end

--teeme päringu, kus kasutame case-i
 --tuleb kasutada ka left join
select E. Name as Employee, case when M. Name is null then 'No Manager'
else M. Name end as Manager
from Employees E
left join Employees M
on E. ManagerId = M. Id

--lisame tabelisse uued veerud
alter table Employees 
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30);

--muudame koodi employees
CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    MiddleName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NULL,
    Gender NVARCHAR(10),
    Salary INT,
    DepartmentId INT NULL,
    ManagerId INT NULL
);

INSERT INTO Employees (Id, FirstName, MiddleName, LastName, Gender, Salary, DepartmentId, ManagerId)
VALUES 
(1, 'Tom', 'Nick', 'Jones', 'Male', 4000, 1, NULL),
(2, 'Pam', NULL, 'Anderson', 'Female', 3000, 3, 1),
(3, 'John', NULL, NULL, 'Male', 3500, 1, 1),
(4, 'Sam', NULL, 'Smith', 'Male', 4500, 2, 2),
(5, NULL, 'Todd', 'Someone', 'Male', 2800, 2, 2),
(6, 'Ben', 'Ten', 'Sven', 'Male', 7000, 1, 2),
(7, 'Sara', NULL, 'Connor', 'Female', 4800, 3, 3),
(8, 'Valarie', 'Balerine', NULL, 'Female', 5500, 1, 3),
(9, 'James', '007', 'Bond', 'Male', 6500, NULL, 3),
(10, NULL, NULL, 'Crowe', 'Male', 8800, NULL, 4);

--igast reast võtab esimesena mitte nulli väärtuse ja paneb Name veergu
--kasutada coalesce
select Id, coalesce (FirstName, MiddleName, LastName) as Name
from Employees

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutate union all
--kahe tabeli andmete vaatamiseks
-- Valime andmed esimesest tabelist
select Id, Name, Email from Indian Customers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtuste eemaldamiseks kasutame unionit
select Id, Name, Email from Indian Customers
union
select Id, Name, Email from UKCustomers

--kuidas tulemust sorteerida nime järgi
--kasutada union all-i
select Id, Name, Email from Indian Customers
union all
select Id, Name, Email from UKCustomers
order by Name


