--=======Assignment 01=======--
use iti

---1. Retrieve a number of students who have a value in their age. 
select count(St_age) 
from Student

---2. Display number of courses for each topic name 
select distinct topic.top_name, COUNT(Crs_Name) over (partition by topic.top_name) 'Course count'
from Course , topic
where Course.Top_Id = Topic.Top_Id

---3. Select Student first name and the data of his supervisor 
select std.St_Fname 'Student Name', Instructor.Ins_Name
from Student std
inner join Instructor on std.St_super = Instructor.Ins_Id

---4. Display student with the following Format (use isNull function)
--Student ID Student Full Name Department name
select std.St_Id 'Student ID ',std.St_Fname + isnull(std.St_Lname,'') 'Full Name' , dep.Dept_Name 'Department name'
from Student std inner join Department dep 
on dep.Dept_Id = std.Dept_Id


---5. Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function” 
select Ins_Name,isnull(salary,0000) 
from Instructor

---6. Select Supervisor first name and the count of students who supervises on them
select Instructor.Ins_Name, count(st_fname) 'students count'
from Instructor 
left join Student 
on Student.St_super = Instructor.Ins_Id
GROUP BY Instructor.Ins_Name

---7. Display max and min salary for instructors
select min(salary) 'min salary',MAX(salary) 'max salary'
from Instructor

---8. Select Average Salary for instructors 
select avg(salary) 'Average salary'
from Instructor

---9. Display instructors who have salaries less than the average salary of all instructors.

select ins.Ins_Name , ins.salary
from Instructor ins
where ins.salary < 
(select
avg(ins.salary)
from Instructor ins)

---10. Display the Department name that contains the instructor who receives the minimum salary
select dep.Dept_Name
from Department dep
inner join Instructor ins
on ins.Dept_Id = dep.Dept_Id
where ins.Salary = (select min(ins.salary) 'Min salary' from Instructor ins)



--=======Assignment 02=======--
use MyCompany
---1. For each project, list the project name and the total hours per week (for all employees) spent on that project.

select p.Pname,sum(w.hours) 'Total hours'
from Project p
inner join Works_for w on p.Pnumber = w.Pno
group by p.Pname

---2. For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

select dep.Dname, max(emp.salary) 'max salary', min(emp.salary) 'min salary' ,avg(emp.salary) 'avg salary'
from Departments dep inner join Employee emp
on dep.Dnum = emp.Dno
group by dep.Dname


---3. Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.

select emp.Fname + ' ' + emp.Lname 'Full Name', p.Pname,dep.dname
from Employee emp inner join Works_for w 
on emp.SSN = w.ESSn
INNER JOIN Project p ON p.Pnumber = w.Pno
INNER JOIN Departments dep on emp.Dno = dep.Dnum ORDER BY dep.Dname, emp.Lname , emp.Fname 


---4. Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%

UPDATE emp SET Salary = Salary + Salary * 0.3 FROM Employee emp
INNER JOIN Works_for w ON w.ESSn = emp.SSN
INNER JOIN Project p ON w.Pno = p.Pnumber WHERE p.Pname = 'Al Rabwah';

--====DML====--
---1. In the department table insert a new department called "DEPT IT" , with id 100, employee with SSN = 112233 
---as a manager for this department. The start date for this manager is '1-11-2006'.
insert into Departments(Dname, Dnum, MGRSSN, [MGRStart Date]) VALUES('DEPT IT', 100, 112233, '1-11-2006');

---2. Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100),
--and they give you(your SSN =102672) her position (Dept. 20 manager) 
--a. First try to update her record in the department table
update dep SET dep.MGRSSN = 968574 
FROM Departments dep where dep.Dnum = 100;

--c. Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)

update emp SET emp.Superssn = 102672 FROM Employee emp WHERE emp.SSN = 102660;

---3. Unfortunately the company ended the contract with  Mr.Kamel Mohamed (SSN=223344)
--so try to delete him from your database in case you know that you will be temporarily in his position.
---Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handles these cases).

select Dependent_name 
from Dependent where ESSN = 223344;

select Dname
from Departments where MGRSSN =223344

select Fname from Employee where Superssn = 223344;

select p.Pnumber from Works_for w
inner join Employee emp on w.ESSn = emp.SSN 
inner join Project p on p.Pnumber = w.Pno
where w.ESSN = 223344;
