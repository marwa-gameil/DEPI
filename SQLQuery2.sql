select * from Employees
insert into Employees values 
('Marwa','Gameil','F','02-01-2003',NULL,3,20000)
update Employees set Salary = Salary*3
where Gender ='F'
and day(birthdate) =01 
and month(birthdate) =02

delete from Employees where
Gender = 'M' and Super_SSN = 1;

delete from Employees where 
month(birthdate) =8

begin transaction
delete from Employees where 
month(birthdate) =02
select @@ROWCOUNT as DeletedROWS
rollback;


