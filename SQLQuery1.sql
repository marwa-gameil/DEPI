--select @@version
--select @@SERVERNAME
--declare @name char(10) = 'marwa samy'
--print @name;
--set @name = 'ahmed samy'
--print @name
--declare @number as dec(6,2) = 5000.249687520
--print @number
------------------------------------
create database Company
use Company
create table Employees (
SSN int primary key identity(1,1),
Fname varchar(15) not null, -- required
Lname varchar(15),
Gender char(1), --M    F
Birthdate date ,
Dnum int,
Super_SSN int references Employees(SSN) --self relationship
)

create table Departments
(
	Dnum int primary key identity(10,10),
	Dname varchar(20) not null,
	Manager_SSN int not null unique references Employees(SSN),
	Hiring_Dates date not null

)
create table Department_Location 
(
	DeptNum int references Departments(Dnum),
	Location varchar(30) default 'Cairo',
	primary key(DeptNum,Location) -- composite pk
)
create table Projects
(
	PNum int primary key identity,
	PName varchar(50) not null,
	Location varchar(20),
	City varchar(20),
	DeptNum int references Departments(Dnum)

)
create table Dependants
(
	Name varchar(40) ,
	Birthdare date,
	Gender char(1),
	ESSN int references Employees(SSN),
	primary key(Name , ESSN)
)
create table Employee_Projects
(
	ESSN int references Employees(SSN),
	PNum int references Projects(PNum),
	NumOfHours tinyint ,
	primary key(ESSN,PNum)
)
select * from Employees
insert into Employees values ('Mona','Ali','F','02-05-2000',NULL,NULL)
DELETE FROM Employees
WHERE SSN = 2;
insert into Employees values ('Ahmed','Mokhtar','M','04-01-2002',NULL,NULL),
('Hossam','Mohsen','M','08-09-2001',NULL,1),
('Aya','Ahmed','F','08-01-1995',NULL,1)
ALTER TABLE Employees
ADD Salary int;
UPDATE Employees
SET Salary = 10000
WHERE Salary IS NULL;

UPDATE Employees
SET Salary += 5000
WHERE Gender = 'F' and CURRENT_TIMESTAMP ;






