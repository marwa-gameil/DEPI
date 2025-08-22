--=============ASSIGNMENT PART 01=====================--
use ITI
 select * from Student
insert into Student (St_Id , St_Fname ,St_Lname ,St_Address , St_Age , Dept_Id)
values (21 , 'Marwa' , 'Gameil' , 'Tanta' ,22 , 30 );

select * from Instructor
insert into Instructor(Ins_Id , Ins_Name ,Ins_Degree ,Salary , Dept_Id)
values (16 , 'Hadeer' , 'PHD' ,4000 , 30 );

UPDATE instructor
SET salary = salary * 1.20;


-----===ASSIGNMENT PART 02===------
-- 1)
---1.Display all the employees Data.
select * from Employee;
---2.Display the employee First name, last name, Salary and Department number.
select Fname,Lname,Salary,Dno from Employee;
---3.Display all the projects names, locations and the department which is responsible for it.
select Pname, Plocation,Dnum from project;
---4.If you know that the company policy is to pay an annual commission for
---each employee with specific percent equals 10% of his/her annual salary 
---.Display each employee full name and his annual commission in an ANNUAL COMM column (alias).

select Fname +' '+ Lname as FullName  
, (salary *12 * 0.10) AS ANNUALCOMM  from Employee
---5.Display the employees Id, name who earns more than 1000 LE monthly.
select SSN ,Fname+' '+Lname as Fullname ,Salary from Employee
where Salary > 1000;
---6.Display the employees Id, name who earns more than 10000 LE annually.
select SSN, Fname+ ' ' + Lname as FullName, (Salary*12) as AnnualSalary From Employee 
where(Salary*12) > 10000
--7.Display the names and salaries of the female employees 
select Fname+' '+Lname as Fullname ,Salary from Employee
where Sex = 'F';
--8.Display each department id, name which is managed by a manager with id equals 968574.
select Dnum, Dname from Departments
where MGRSSN =968574;
--9.Display the ids, names and locations of  the projects which are controlled with department 10.
select Pnumber,Pname,Plocation from Project
where Dnum = 10;
--=============ASSIGNMENT PART 03=====================--
use ITI
--1.Get all instructors Names without repetition
select distinct ins_name from Instructor
--2.Display instructor Name and Department Name 
--Note: display all the instructors if they are attached to a department or not
select Ins_Name,Dept_Name from  Instructor left join Department on Instructor.Dept_Id = Department.Dept_Id
---3.Display student full name and the name of the course he is taking
---For only courses which have a grade 

select St_Fname+' '+St_Lname as FullName ,crs_name from Student inner join Stud_Course  on Student.St_Id = Stud_Course.St_Id
inner join Course on Stud_Course.Crs_Id= Course.Crs_Id
where Stud_Course.Grade is not null

---Bouns
---Display results of the following two statements and 
---explain what is the meaning of @@AnyExpression
---select @@VERSION
---select @@SERVERNAME
select @@VERSION;
select @@SERVERNAME;


--=============ASSIGNMENT PART 04=====================--
use MyCompany
---1.Display the Department id, name and id and the name of its manager.

select dnum,Dname,MGRSSN,fname + ' '+ lname as fullName from Departments 
inner join Employee on Employee.SSN =Departments.MGRSSN

---2.Display the name of the departments and the name of the projects under its control.

select dname,pname from Departments inner join Project on Departments.Dnum = Project.Dnum

---3.Display the full data about all the dependence associated with the name of the employee they depend on

select Dependent_name,dependent.Sex,dependent.Bdate,Fname+' ' + lname as fullName from Dependent left join Employee on Employee.SSN = Dependent.ESSN

--4.Display the Id, name and location of the projects in Cairo or Alex city.
select Pnumber,Pname,Plocation from Project
where City ='Cairo' or City='Alex';
--5.Display the Projects full data of the projects with a name starting with "a" letter.
select * from Project
where Pname like 'a%';
--6.display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select Fname+' '+Lname Fullname,Salary from Employee
where Dno=30 and Salary between 1000 and 2000;

---7.Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.

select fname+' ' + Lname as FullName,Departments.dnum from Employee inner join Departments on Departments.Dnum =10
inner join Works_for on Employee.SSN = Works_for.ESSn 
inner join Project on Project.Pnumber = Works_for.Pno
where Works_for.Hours >= 10 and Pname = 'AL Rabwah'


---8.Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

select Fname+' ' +lname as fullName,Project.Pname from Employee 
inner join Works_for on Employee.SSN=Works_for.ESSn 
inner join Project on Project.Pnumber = Works_for.Pno
order by Project.Pname

---9.For each project located in Cairo City , find the project number, the controlling department name
---,the department manager last name ,address and birthdate.

select pnumber,Dname,Lname,Employee.Address,Employee.Bdate from Project 
inner join departments on Departments.Dnum = Project.Dnum 
inner join Employee on Employee.SSN = Departments.MGRSSN
where city = 'Cairo'
