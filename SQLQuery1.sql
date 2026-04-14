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

-- rida 502
-- 4 tund -- 31.03.2026
select ISNULL('Sinu Nimi', 'No Manager') as Manager

select coalesce(null, 'No Manager') as Manager

--Neil kellel ei ole �lemust, siis paneb neile No Manager teksti
select E.Name as Employee, isnull(M.Name, 'No Manager') as manager
from Employees E
left join Employees M
on E.ManagerID = M.ID

-- kui Expression on �ige, siis paneb v��rtuse, mida soovid v�i vastasel juhul paneb No manager teksti
case when Expression Then '' else '' end

-- teeme p�ringu, kus kasutame case-i, tuleb kasutada ka left join
select E.Name as Employee, case	when M.Name is NULL	Then 'No Manager'
else M.Name end as Manager
from Employees E
left join Employees M
on E.ManagerID = M.ID

--lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add Lastname nvarchar(30)

--muudame veeru nime koodiga
sp_rename 'Employees.MiddleName1', 'MiddleName'
select * from Employees

update Employees
set MiddleName = 'Nick', LastName = 'Jones' where id = 1
update Employees
set LastName = 'Anderson' where id = 2
update Employees
set LastName = 'Smith' where id = 4
update Employees
set MiddleName = 'Todd', FirstName = NULL, LastName = 'Someone' where id = 5
update Employees
set MiddleName = 'Ten', LastName = 'Sven' where id = 6
update Employees
set LastName = 'Connor' where id = 7
update Employees
set MiddleName = 'Balerine' where id = 8
update Employees
set MiddleName = '007', LastName = 'Bond' where id = 9
update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe' where id = 10

--igast reast v�tab esimesena mitte nulli v��rtuse ja panemb Name veergu kasutada coalesce
select id, coalesce(FirstName, MiddleName, LastName) as Name --coalesce v�tab v��rtused j�rjest l�bi, kui 1 on NULL siis v�tab teise, kui see ka NULL, siis kolmas, kui k�ik NULL siis annab v��rtuse NULL
from Employees

create table IndianCustomers
(
ID int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
ID int identity(1,1),
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

--kasutate union all kahe tabeli andmete vaatamiseks, n�itab m�lema tabeli read �hes tabelis
select * from IndianCustomers
Union all
select * from UKCustomers

--korduvate v��rtuste eemaldamiseks kasutame union
select * from IndianCustomers
Union
select * from UKCustomers

--kuidas tulemust sorteerida nime j�rgi, kasutada union all-i
select * from IndianCustomers
Union all 
select * from UKCustomers
order by Name

--stored procedure
--salvestatud protseduurid on SQL'i koodid, mis on salvestatud andmebaasis ja mida saab
--k�ivitada, et teha mingi kindel t�� �ra
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--n��d saame kasutada spGetEmployees'i
spGetEmployees
exec spGetEmployees
execute spGetEmployees -- k�ik annavad sama tulemuse

---
create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(10),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentID from Employees
	where Gender = @Gender and DepartmentId = @DepartmentId
end

--ilma @ parameetriteta annab errori
spGetEmployeesByGenderAndDepartment 'male', 1
--kuidas minna sp j�rjekorrast m��da --kirjuta v�lja parameetrid
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'male'

sp_helptext spGetEmployeesByGenderAndDepartment

--muudame sp'd ja v�ti peale, et keegi teine peale teie ei saaks seda muuta.
alter procedure spGetEmployeesByGenderAndDepartment
@Gender nvarchar(10),
@DepartmentId int
with encryption -- paneb v�tme peale
as begin
	select FirstName, Gender, DepartmentID from Employees
	where Gender = @Gender and DepartmentId = @DepartmentId
end

--
create proc spGetEmployeeCountByGender
@Gender nvarchar(10),
--mis on output parameeter ja kuidas seda kasutada
--on parameeter, mis v�imaldab meil salvestada protseduuri
--sees tehtud arvutuse tulemuse ja kasutada seda v�ljaspool protseduuri
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab �ra n�uetele vastavad read, prindib tulemuse, mis on parameetris @EmployeeCount
declare @TotalCount int
exec spGetEmployeeCountByGender 'male', @TotalCount output -- output sama mis out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@TotalCount is not null'
print @TotalCount

--n�itab �ra mitu rida vastab n�uetele
declare @TotalCount int
--out on parameeter, mis v�imaldab meil salvestada protseduuri
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info
sp_help Employees
--kui soovid sp teksti n�ha
sp_helptext spGetEmployeeCountByGender

--vaatame, millest s�ltub see sp
sp_depends spGetEmployeeCountByGender
--vaatame tabelit sp_depends'ga
sp_depends Employees

---
create proc spGetNameById
@Id int,
@Name nvarchar(25) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

--tahame n�ha kogu tabelite ridade arvu, count kasutada
create proc spGetRowCount
@IdCount int output
as begin
	select @IdCount = COUNT(Id) from Employees
end

spGetRowCount

declare @TotalEmployees int
execute spGetRowCount @TotalEmployees out
select @TotalEmployees as Eployees

--mis id all on keegi nime j�rgi
create proc spGetNameByID1
@Id int,
@FirstName nvarchar(30) output
as begin
	select @FirstName = FirstName from Employees where @Id = Id
end

--annab tulemuse, kus id 1 real on keegi koos nimega
declare @FirstName nvarchar(30)
exec spGetNameByID1 1, @FirstName out
print 'Name of employee = ' + @Firstname

---
declare @FirstName nvarchar(30)
exec spGetNameById 3, @FirstName output
print 'Name of employee = ' + @FirstName
-- ei anna tulemust, sest sp's on loogika viga. sest @ Id on parameeter, mis on m�eldud selleks,
--et me saaksime sisestada id'd ja saada nime, aga sp's on loogika viga, sest see �ritab m��rata
--@Id v��rtuseks Id veeru v��rtust, mis on vale

--rida 718
--tund 5 -- 07.04.26
declare @FirstName nvarchar(30)
exec spGetNameById 1, @FirstName out
print 'Name of employee = ' + @FirstName

sp_help spGetNamebyId

create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end

declare @EmployeeName nvarchar(30)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

alter proc spGetNameById2
@Id int
as begin
	select FirstName from Employees where Id = @Id
end
--return annab ainult int t��pi v��rtuset, seega ei saa kasutada returni, et tagastada nime, mis
--on nvarchar t��pi

----sisseehitatud string funktsioonid
-- see konventeerib ASCII t�he v��rtuse numbriks
select ascii('A')
-- kuvab A-t�hr
select char(65)

--prindime kogu t�hestiku v�lja A-st Z-ni
--kasutame while ts�klit
declare @x INT
set @x = 65
while @x <= ascii('Z')
begin
	print char(@x)
	set @x = @x + 1
end

-- eemaldame t�hjad kohad sulgudes
select ltrim('                              Hello')

-- t�hikute eemaldamine s�nas
select ltrim(FirstName) as FirstName, Middlename, Lastname
from Employees

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt upper ja lower'ga saan muuta m�rkide suurust
--reverse funktsioon keerab stringi tagurpidi
select reverse(upper(ltrim(FirstName))) as FirstName, MiddleName,
lower(Lastname), rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + 
LastName as FullName from Employees


--left, right, substring
--left / right v�ta stringi vasakult / paremalt poolt neli esimest t�hte
select left('ABCDEF', 4)
select right('ABCDEF', 4)

--kuvab @t�hem�rgi asetust
select CHARINDEX('@', 'sara@aaa.com')

--alates viiendast t�hem�rgist v�tab kaks t�hte
select substring('leo@bbb.com', 5, 2)

--- @-m�rgist kuvab kolm t�hem�rki. Viimase nr saab m��rata pikkust
select substring('leo@bbb.com', charindex('@', 'leo@bbb.com') + 1, 3)

---peale @-m�rki reguleerin t�hem�rkide pikkuse n�itamist
select substring('leo@bbb.com', CHARINDEX('@', 'leo@bbb.com') + 2,
len('leo@bbb.com') - CHARINDEX('@', 'leo@bbb.com'))

--saame teada domeeninimed emalides, kasutame Person tabelit
--ja substringi, len ja charindex
select substring(Email, CHARINDEX('@', Email) + 1,
len(Email) - charindex('@', Email)) as Domainname
from Person


alter table Employees
add Email nvarchar(20)

update Employees
set Email = 'Tom@aaa.com' where Id = 1
update Employees
set Email = 'Pam@bbb.com' where Id = 2
update Employees
set Email = 'John@aaa.com' where Id = 3
update Employees
set Email = 'Sam@bbb.com' where Id = 4
update Employees
set Email = 'Todd@bbb.com' where Id = 5
update Employees
set Email = 'Ben@ccc.com' where Id = 6
update Employees
set Email = 'Sara@ccc.com' where Id = 7
update Employees
set Email = 'Valarie@aaa.com' where Id = 8
update Employees
set Email = 'James@bbb.com' where Id = 9
update Employees
set Email = 'Russel@bbb.com' where Id = 10

--lisame *-m�rgi alates teatud kohast
select FirstName, LastName,
	substring(Email, 1, 2) + replicate('*', 5) +
	--peale tesist t�hem�rki paneb viis t�rni
	substring(Email, charindex('@', Email), len(Email)
	- len(charindex('@', Email) + 1)) as MaskedEmail
	--kuni@m�rgini paneb t�rnid ja siis j�tkab emaili n�itamist on
	--d�naamiline, sest kui emaili pikkus on erinev, siis paneb
	--vastavalt t�hed
from Employees

--kolm korda n�itab stringis olevat v��rtust
select replicate ('Hello', 3)

--kuidas sisestada t�hikut kahe nime vahele, kasutada funktsiooni
select space(5)
--v�tame tabeli Employees ja kuvame eesnimi ja perekonnanime vahele t�hikut
select FirstName + space(1) + LastName as Fullname from Employees

--PATINDEX
--sama, mis charindex, aga patindex v�imaldab kasutada wildcardi
--kasutame tabelit Employees ja leiame k�ik read, kus emaili l�pus on aaa.com
select Email, patindex('%@aaa.com',Email) As Position from Employees
where patindex('%@aaa.com',Email) > 0
--leiame k�ik read, kus emaili l�pus on aaa.com v�i bbb.com


--asendame emaili l�pus olevat domeeninimed, .com asemel .net'ga, kasutage replac'i
select replace(Email, '.com', '.net') from Employees

--soovin asendada peale esimest m�rki olevad t�hed viie t�rniga
select Firstname, lastname, Email,
stuff(Email, 2, 3, '*****') as StuffedEmail from Employees

---ajaga seotud andmet��bid
create table DateTest
(c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTest

--sinu masina kellaaeg
select getdate() as CurrentDateTime

insert into DateTest
values (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

update DateTest set c_datetimeoffset = '2026-04-07 12:13:09.6066667 +02:00'
where c_datetimeoffset = '2026-04-07 17:13:09.6066667 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja p�ring
select SYSDATETIME(), 'SYSDATETIME()' --veel t�psem aja p�ring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET()' --t�pne aja ja ajav��ndi p�ring
select GETUTCDATE(), 'GETUTCDATE()' --UTC aja p�ring

select isdate('asdasd') --tagastab 0, sest see ei ole kehtiv kuup�ev
select isdate(getdate()) --tagastab 1, sest on kuup�ev
select isdate('2026-04-07 17:13:09.6066667 +00:00') --tagastab 0 kuna mx kolm komakohta v�ib olla
select isdate('2026-04-07 17:13:09.606') --tagastab 1
select day(getdate()) --annab t�nase p�eva numbri
select day('03/29/2026') --annab stringis oleva kp ja j�rjestus peab olema �ige
select month(getdate()) --kuu
select month('03/29/2026') --kuu
select year(getdate()) --aasta
select year('03/29/2026') --aasta


--rida 841
--tund 6
--14.04.26
select datename(day, '2026-04-07 12:00:05.056')--annab stringis oleva päeva nime
select datename(weekday, '2026-04-07 12:00:05.056')--annab stringis oleva päeva nime
select datename(month, '2026-04-07 12:00:05.056')--annab stringis oleva kuu nime

create table EmployeesWithDates
(
	Id nvarchar(2),
	Name nvarchar(20),
	DateOfBirth datetime
)

INSERT INTO EmployeesWithDates (Id, Name, DateOfBirth)
VALUES (1, 'Sam', '1980-12-30 00:00:00.000');
INSERT INTO EmployeesWithDates (Id, Name, DateOfBirth)
VALUES (2, 'Pam', '1982-09-01 12:02:36.260');
INSERT INTO EmployeesWithDates (Id, Name, DateOfBirth)
VALUES (3, 'John', '1985-08-22 12:03:30.370');
INSERT INTO EmployeesWithDates (Id, Name, DateOfBirth)
VALUES (4, 'Sara', '1979-11-29 12:59:30.670');

--kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud
select Name, DateOfBirth, Datename(weekday, DateOfBirth) as [Day],
		MONTH(DateOfBirth) as [Month ],
		DATENAME(month, DateOfBirth) as [MonthName],
		YEAR(DateOfBirth) as [Year]
from EmployeesWithDates

select DATEPART (weekday, '2026-04-07 12:00:05.056')--annab stringis oleva päeva nr, kus 1 on pühapäev
select DATEPART(month, '2026-04-07 12:00:05.056')--annab stringis oleva kuu nr
select DATENAME (week, '2026-04-07 12:00:05.056')
select dateadd(day, 20, '2026-04-07 12:00:05.056')--annab stringis oleva kuupäeva, mis on 20 päeva pärast
select dateadd(day, -20, '2026-04-07 12:00:05.056')--annab stringis oleva kuupäeva, mis on 20 päeva enne
select datediff(month, '04/30/2025', '01/31/2026')
select datediff(year, '104/30/2025', '01/31/2026')

create function fnComputeAge (@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
	select @tempdate = @DOB

	-case when (month(@ select @years datediff(year, @tempdate, getdate()) - case when (month(@DOB)
	= month(getdate()) and day (@DOB) > day(getdate()) then 1 else 0 end
	select @tempdate dateadd(year, @years, @tempdate)

	select @months =datediff(month,@tempdate,getdate()) - case when day (@DOB) > day(getdate()) then 1 else 0 end
	select @tempdate = dateadd(month,@months,@tempdate)

	select @days = datediff(day,@tempdate, getdate())

	declare @Age nvarchar(50)
		set @Age cast(@years as nvarchar(10)) + 'years, ' 
		+ cast(@months as nvarchar(10)) + 'months,' 
		+ cast(@days as nvarchar(10)) + 'day old'
	return @Age
end

--saame vanuse välja arvutada, kui kasutame fnComputeAge funktsiooni
select Name, DateOfBirth, dbo fnComputeAge (DateOfBirth) as Age
from EmployeesWithDates

--kui kasutame seda funktsiooni, siis saame teada tänase päeva vahet
--stringis olevaga
select dbo.fnComputeAge('03/23/2008')

--nr peale DOB muutujat näitab,
--et missugusena järjestuses me tahame näidata veeru sisu
select Id, Name, DateOfBirth,
convert(nvarchar, DateOfBirth, 126) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id]
from EmployeesWithDates

select cast(getdate() as date) --tänane kp
select convert(date, getdate()) --tänane kp

---matemaatilised funktsioonid
select abs(-101.5) --absoluutväärtus, tagastab 101.5
select ceiling (101.5) --taqastab 102, ümardab üles

---matemaatilised funktsioonid
select abs(-101.5) --absoluutväärtus, tagastab 101.5
select ceiling (101.5) --tagastab 102, ümardab üles
select CEILING(-101.5) --tagastab -101, ümardab üles positiivsema nr poole
select floor (101.5) --tagastab 101, ümardab alla
select floor(-101.5) --tagastab -102, ümardab alla negatiivsema nr poole
select power(2, 4) -- 2 astmel 4 e 2x2x2x2, esimene nr on alus

