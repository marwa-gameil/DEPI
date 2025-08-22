Use ITI
--======ASSIGNMENT=======--
--1.  Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

go
create function MyFunc(@start int , @end int)
returns @nums table(result int)
as
begin
declare @num int
set @num = @start
while @num <= @end

begin
insert into @nums(result)
Values(@num)
set @num = @num +1;
end
return
end
go

select * from dbo.MyFunc(1,5)



--2.  Create a table-valued function that takes Student No and returns Department Name with Student full name.


go
create function GetDeptNameByStdNum(@std_num int)
returns @result table(deptName varchar(20), fullName varchar(50))
as
begin
insert into @result (deptName,fullName)

select d.Dept_Name , CONCAT_WS(' ',s.st_fname,s.st_lname)
from Student s
inner join Department d on s.Dept_Id = d.Dept_Id
where s.St_Id = @std_num
return
end
go

select * from dbo.GetDeptNameByStdNum(1)


--3. Create a function that takes an integer which represents the format of the Manager hiring date and displays department name,
--Manager Name and hiring date with this format.   


go
create function GetManagersByDateFormat(@format INT)
returns @result table (hiringDate varchar(50), deptName varchar(20),ManagerName varchar(20))
as
begin
insert into @result (hiringDate,deptName,ManagerName)
select d.Dept_Name, CONCAT_WS(' ' ,s.St_Fname,s.St_Lname) as [Manager Name],
CONVERT(varchar(20), d.Manager_hiredate, @format) as [Hiring Date]
from Department d
inner join Student s on d.Dept_Manager = s.St_Id

return
end
go

SELECT * FROM dbo.GetManagersByDateFormat(101)



--4. Create multi-statement table-valued function that takes a string
--a. If string='first name' returns student first name
--b. If string='last name' returns student last name 
--c. If string='full name' returns Full Name from student table  
--Note: Use “ISNULL” function

go
create function GetFormat(@name varchar(20))
returns @NameFormat table(StdName varchar(20))
as
begin
if @name ='first name'
insert into @NameFormat 
select ISNULL(s.st_fname,'Not EXist' )
from Student s
else if @name = 'last name'
insert into @NameFormat
select ISNULL(s.st_lname,'Not EXist' )
from Student s
if @name = 'full name'
insert into @NameFormat
select concat_ws(' ',isnull( s.st_fname,'Not Exist'),isnull( s.st_lname,'Not Exist'))
from student s
return
end
go

select * from dbo.GetFormat('first name')
select * from dbo.GetFormat('last name')
select * from dbo.GetFormat('full name')

--. Create a scalar function that takes Student ID and returns a message to user 

go
create function GetMessage(@std_id int)
returns varchar(100)
as
begin
declare @message varchar(100)
select @message = 'Hey,'+St_Fname
from student
where @std_id = Student.St_Id
return @message
end
go

select dbo.GetMessage(1)


use MyCompany
--5. Create function that takes project number and display all employees in this project (Use MyCompany DB)


go
create function GetEmployees(@projectNum int)
returns table
as
return
select e.SSN,e.Fname,e.Lname, e.Salary, d.Dname AS DepartmentName,
        w.Hours
from
Works_for w inner join Employee e on  e.SSN = w.ESSn
inner join
Departments d on e.Dno = d.Dnum
where w.Pno =@projectNum
go

SELECT * FROM dbo.GetEmployees(100);


--6. Create a scalar function that takes a date and returns the Month name of that date.

go
create function GetMonth(@monthName date)
returns varchar(20)
begin
declare @mName varchar(20) 
select @mName = DATENAME(Month,@monthName)
return @mName
end
select dbo.GetMonth('2003-02-01')


