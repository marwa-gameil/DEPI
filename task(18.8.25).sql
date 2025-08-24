--==Basic User Defined View
--1.student in cairo

use iti
go
create or alter view dbo.VCairoStudents
AS
select St_Id , St_Fname, St_Address
from Student
where St_Address = 'Cairo'

select * from VCairoStudents

go
create or alter view dbo.VAlexStudents
AS
select St_Id , St_Fname, St_Address
from Student
where St_Address = 'Alex'

select * from VAlexStudents

go
--2. students and their departments
go
create or alter  view dbo.VStudentsInDepartment
as
select s.St_Id, s.St_Fname, d.Dept_Name
from Student s inner join Department d
on s.Dept_Id =d.Dept_Id
go

select * from VStudentsInDepartment

---hide source code of View
go
create or alter  view dbo.VStudentsInDepartment
with encryption
as
select s.St_Id, s.St_Fname, d.Dept_Name
from Student s inner join Department d
on s.Dept_Id =d.Dept_Id
go

select * from VStudentsInDepartment

sp_helptext 'VStudentsInDepartment' --won't work

--3. view brings student and their courses and their grades
go
create or alter view dbo.VStudentWithCoursesAndGrades
as
select s.St_Fname  ,co.Crs_Name,c.Grade
from Student s inner join stud_Course c
on s.St_Id = c.St_Id
inner join Course co on c.Crs_Id = co.Crs_Id
go
select * from VStudentWithCoursesAndGrades

---===Partitioned view => uses more than one select statements
go
create or alter view dbo.VCairoAlexStudents
with encryption
as
select * from VCairoStudents
union all
select * from VAlexStudents
go
select * from VCairoAlexStudents

--===ASSIGNMENT 01 ====
--1.Create a view that displays the student's full name, course name if the student has a grade more than 50. 
go
create or alter view dbo.VStudentWithCourse
as
select CONCAT_WS(' ', s.St_Fname,s.St_Lname) 'Full Name'  ,co.Crs_Name,c.Grade
from Student s inner join stud_Course c
on s.St_Id = c.St_Id
inner join Course co on c.Crs_Id = co.Crs_Id
where c.Grade >50
go
select * from VStudentWithCourse

--2.Create an Encrypted view that displays manager names and the topics they teach. 
go
create or alter view dbo.VMangerWithTopics
with encryption
as
select ins.Ins_Name , c.Crs_Name
from Instructor ins inner join Ins_Course ic
on ins.Ins_Id = ic.Ins_Id
inner join Course c on ic.Crs_Id = c.Crs_Id
go
select * from VMangerWithTopics

--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” 
--and describe what is the meaning of Schema Binding
go
create or alter view dbo.VSelectedInsWithDept
with schemabinding
as
select i.Ins_Name, d.Dept_Name
from dbo.Instructor i
inner join dbo.Department d on i.Dept_Id = d.Dept_Id
where d.Dept_Name = 'SD' or d.Dept_Name = 'Java';
go
select * from VSelectedInsWithDept


-- schema binding => if you have a view with schema binding on a table’s column, you cannot drop or alter that column unless you first remove schema binding.



--4.Create a view “V1” that displays student data for students who live in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;
go
create or alter view dbo.V1
AS
select *
from Student
where St_Address = 'Cairo' or  St_Address = 'Alex'
WITH CHECK OPTION;
go

select * from V1


--0.Create a view that will display the project name and the number of employees working on it. (Use Company DB)
use MyCompany
go
create view ProjectNameAndEmployeeCount
as
select p.Pname , count(w.essn) 'employee count'
from Project p inner join Works_for w
on p.Pnumber = w.Pno
group by p.Pname
go

select * from ProjectNameAndEmployeeCount

--------------------------------------------------



use IKEA_Company 

select * from Company.Department
select * from HR.Employee
select * from Works_on

select * from AuditTable1
select * from Department
select * from HR.Project

--1.Create a view named “v_clerk” that will display employee Number, project Number, the date of hiring of all the jobs of the type 'Clerk'.
go
create or alter view dbo.v_clerk
as
select e.EmpNo , w.ProjectNo , w.Enter_Date
from HR.Employee e inner join Works_on w
on e.EmpNo = w.EmpNo
where w.job = 'Clerk'

select * from v_clerk
go


--2.Create view named  “v_without_budget” that will display all the projects data without budget
go
create or alter view dbo.v_without_budget
as
select *
from HR.Project
where Budget is null
go

select * from v_without_budget

--3.Create view named  “v_count “ that will display the project name and the Number of jobs in it
go
create or alter view dbo.v_count
as
	select p.ProjectName , COUNT(w.job) 'Jobs Count'
	from  Works_on w inner join  HR.Project p 
	on p.ProjectNo = w.ProjectNo
	group by p.ProjectName
go
select * from v_count


--4.Create a view named” v_project_p2” that will display the emp# s for the project# ‘p2’.
--(use the previously created view  “v_clerk”)
go
create or alter view dbo.v_project_p2
as
select EmpNo
from v_clerk 
where ProjectNo = 2 
go
select *  from v_project_p2

--5.modify the view named “v_without_budget” to display all DATA in project p1 and p2.
go
alter view v_without_budget
as
select *
from HR.Project  
where ProjectNo = 1 or ProjectNo = 2
go
select * from v_without_budget

--6.Delete the views  “v_ clerk” and “v_count”
drop view v_clerk 
drop view  v_count

--7.Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
go
create or alter view dbo.VEmbWorks
as
select E.EmpNo , e.EmpLname
from HR.Employee e
where e.DeptNo = 2
go
select * from VEmbWorks
--8.Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)

select  EmpLname 
	from VEmbWorks
	where EmpLname like '[j]%'

--9.Create view named “v_dept” that will display the department# and department name

go
create or alter view dbo.v_dept 
as
select DeptName,DeptNo
from Department
go 
select * from v_dept

--10.using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
update v_dept set DeptName='SD',DeptNo=5
where DeptName='Development' and DeptNo=4
select DeptName ,DeptNo from v_dept

--11.Create view name “v_2006_check” that will display employee Number, the project Number where he works and the date of joining
--the project which must be from the first of January and the last of December 2006.
--this view will be used to insert data so make sure that the coming new data must match the condition
go
create or alter view dbo.v_2006_check
as
select e.EmpNo,p.ProjectNo,w.Enter_Date
from hr.Employee e inner join Works_on w
on e.EmpNo = w.EmpNo inner join Hr.Project p
on w.ProjectNo = p.ProjectNo
where w.Enter_Date between '2006-1-1' and'2006-12-31' with check option
go

select * from v_2006_check

------------------------------
--====ASSIGNMENT 02====
USE ITI
--1.Create a stored procedure to show the number of students per department.[use ITI DB] 
go
create or alter proc GetStudentPerDepartment
as
select d.Dept_Name, COUNT(s.st_id) 'Student Count'
from Student s inner join Department d
on s.Dept_Id = d.Dept_Id
group by Dept_Name
go
exec GetStudentPerDepartment

--2.Create a stored procedure that will check for the Number of employees in the project 100 if they are more than 3
--print message to the user “'The number of employees in the project 100 is 3 or more'” if they are less display a message to
--the user “'The following employees work for the project 100'” in addition to the first name and last name of each one.[MyCompany DB] 
use MyCompany
go
create or alter proc GetNumOfEMP(@projNum int)
as
declare @NumOfEmployees int
declare @message varchar(30)
declare @EmpName table(EmpName varchar(20))
select @NumOfEmployees = COUNT(e.ssn)
from Employee e inner join Works_for w
on e.SSN = w.ESSn inner join Project p
on w.Pno = p.Pnumber
where p.pnumber=@projNum
group by p.pnumber
--3.Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement.
--The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update 
--works_on table. [MyCompany DB]

go
create or alter proc ReplaceEmployee 
(@OldEmpNo int,@NewEmpNo int,@ProjectNo int)
as 
update Works_for
set ESSn = @NewEmpNo
where ESSn = @OldEmpNo and Pno = @ProjectNo;
GO
EXEC ReplaceEmployee 112233, 101020, 200;
