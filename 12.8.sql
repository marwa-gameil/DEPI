use iti
go
create function GetStudentNameByID(@id int )
returns varchar(50)
begin
declare @studentName varchar(50)
select @studentName = concat_ws(' ', st_fname,st_lname)
from student 
where St_Id = @id
return @studentName
end
go

select dbo.GetStudentNameByID(10);

---------------takes department id and return the manager of this department
use MyCompany
create function GetDeptMangerByDeptName(@deptName varchar(20))
returns varchar(20)
begin
declare @manager varchar(20)
select @manager = emp.fname 
from Employee emp inner join Departments dept
on emp.ssn = dept.mgrssn and dept.dname = @deptName
return @manager
end
go
select dbo.GetDeptMangerByDeptName('DP1')

select * from Departments



--------inline table 
-----ex: create func takes dept id and return instructor who works in this dept
use iti
go
create function GetInstByDeptId(@deptID int )
returns table 
as
return(
select ins_id, ins_name,salary,dept_id
from instructor 
where dept_id = @deptID
)
select * from GetInstByDeptId(10)

---------multi statment table
----ex: create function takes parameter formate and returns student name based on formate(first-last-full)
create function GetStudentNameBasedOnFormate2(@formate varchar(20))
returns @data table(stdId int, stdName varchar(20))
as
begin
if @formate = 'first'
insert into @data
select st_id, st_fname 
from student
else if @formate = 'last'
insert into @data
select st_id ,st_lname
from Student
else if @formate = 'full'
insert into @data
select st_id ,CONCAT_WS(' ',St_Fname,St_Lname)
from Student
return 
end
go
select  * from GetStudentNameBasedOnFormate2('first')
select  * from GetStudentNameBasedOnFormate2('last')
select  * from GetStudentNameBasedOnFormate2('full')


--======ASSIGNMENT PART 01=====
use iti
--1.Select max two salaries in the instructor table. 
select distinct Salary 
from Instructor
where Salary in (
select top 2 Salary from Instructor
order by Salary desc)
order by Salary desc

--2.Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
select Dept_Id, Salary
from (
    select ins.Dept_Id, ins.Salary,
    DENSE_RANK() over (PARTITION BY ins.Dept_Id ORDER BY ins.Salary DESC) AS SalaryRank
    from Instructor ins
    where ins.Salary IS NOT NULL
) AS ranked
where SalaryRank <= 2
order by Dept_Id, Salary DESC;

--3.Write a query to select a random  student from each department.  “using one of Ranking Functions”
select * from (
select *,
ROW_NUMBER() OVER (PARTITION BY Dept_Id ORDER BY NEWID() ) as rn
FROM Student 
) as ranked
where rn=2

--======ASSIGNMENT PART 02=====
use AdventureWorks2012
--1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema)
--to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’

select SalesOrderID,ShipDate 
from Sales.SalesOrderHeader
where ShipDate Between '7/28/2002' AND '7/29/2014'


--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select ProductID,Name
from Production.Product
where StandardCost<110

--3.Display ProductID, Name if its weight is unknown

select ProductID,Name 
from Production.Product
where Weight IS NULL

--4.Display all Products with a Silver, Black, or Red Color
select * from Production.Product
where Color in ('Silver','Black','Red')

--5.Display any Product with a Name starting with the letter B
select * from Production.Product
where Name like 'B%'

--6.Run the following Query
--UPDATE Production.ProductDescription
--SET Description = 'Chromoly steel_High of defects'
--WHERE ProductDescriptionID = 3
--Then write a query that displays any Product description with underscore value in its description.

update Production.ProductDescription
set Description = 'Chromoly steel_High of defects'
where ProductDescriptionID = 3

select Description
from Production.ProductDescription
where Description like '%\_%' escape '\'
--7.Display the Employees HireDate (note no repeated values are allowed)
select distinct HireDate from HumanResources.Employee
--8.Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following
--format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)

select concat('The ', Name, ' is only ', ListPrice) AS the_list_price
from Production.Product
where ListPrice BETWEEN 100 AND 120;
