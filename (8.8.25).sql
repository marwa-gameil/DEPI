use mycompany
--======Assignment 03======--
--1. Retrieve the names of all employees in department 10 
--who work more than or equal 10 hours per week on the "AL Rabwah" project.

select concat_ws(' ',emp.Fname,emp.Lname)'Full Name', w.Hours
FROM Employee emp
inner join works_for w on w.ESSn = emp.SSN
inner join project p on w.Pno = p.Pnumber
where emp.Dno = 10 and p.Pname = 'AL Rabwah' and w.Hours >= 10;

--2. Retrieve the names of all employees and the names of the projects they are working on,
--sorted by the project name

select concat_ws(' ',emp.Fname,emp.Lname)'Full Name', p.Pname
FROM Employee emp
inner join Works_for w on w.ESSn = emp.SSN
inner join Project p on p.Pnumber =  w.Pno
order by p.Pname;

--3. For each project located in Cairo City , find the project number, the controlling department name
--,the department manager last name ,address and birthdate.


select p.Pnumber,dep.dname,emp.Lname ,emp.Address,emp.Bdate
from Project p
inner join Departments dep on dep.Dnum = p.Dnum
inner join Employee emp on dep.MGRSSN = emp.SSN
where p.City = 'Cairo'

--4. Display the data of the department which has the smallest employee ID over all employees' ID.

select *
from Departments dep
inner join Employee emp on emp.Dno =dep.Dnum
where emp.SSN = (select min(emp.SSN) from Employee emp INNER JOIN Departments dep ON emp.Dno = dep.Dnum);


--5. List the last name of all managers who have no dependents

select emp.Lname 
from Employee emp
inner join Departments d ON d.MGRSSN = emp.SSN
left join Dependent dep ON dep.ESSN = d.MGRSSN
WHERE dep.Dependent_name IS NULL;


--6. For each department-- if its average salary is less than the average salary of all employees display its number, name and number of its employees.


select d.Dnum, d.Dname, COUNT(emp.SSN)'Employee Number' FROM Departments d
inner join Employee emp ON emp.Dno = d.Dnum
group by d.Dnum,d.Dname
having AVG(emp.Salary) < (select AVG(emp.Salary) from Employee emp)

--7. Try to get the max 2 salaries using subquery
select *
from Employee
where Salary IN (
    select TOP 2 Salary
    from Employee
    order by Salary desc)
order by Salary desc;
