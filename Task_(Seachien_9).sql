create database seachien_99
use seachien_99

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'p')
BEGIN
    EXEC('CREATE SCHEMA p')

END
go

--part 1 :
--create a table Employees with columns: Id, FirstName, LastName, Salary.

-- 1- Create a stored procedure named GetAllEmployees that selects all rows from Employees.
-- 2- Create a stored procedure GetHighSalaryEmployees with one input parameter @MinSalary which Select 
--all employees with Salary > @MinSalary
-- 3- Create AddEmployee SP with @FirstName, @LastName, @Salary which Insert a new row into Employees. 


IF OBJECT_ID('p.Employees', 'U') IS NULL
BEGIN

create table p.Employees 
(
Id int identity primary key ,
FirstName varchar (20),
LastName varchar (20),
Salary DECIMAL 
)
end

create procedure p.usGetAllEmployee
as 
begin 

select *
from p.Employees

end

execute p.usGetAllEmployee

insert into p.Employees (FirstName , LastName , Salary)
values ('zeyad' , 'Fysal', 14000) , 
('Ahmed' , 'khaled', 15000),
('Ezz' , 'Ahmed', 17000),
('Maged' , 'Mohamed', 18000)

create procedure p.usGetHighSalaryEmployees ( @MinSalary int)
as 
begin 

select FirstName , Salary
from p.Employees
where Salary >= @MinSalary
end

execute p.usGetHighSalaryEmployees 15000

-- 3- Create AddEmployee SP with @FirstName, @LastName, @Salary which Insert a new row into Employees. 
go

Create procedure p.usAddEmployee (@FirstName varchar (20), @LastName varchar (20), @Salary int)
as 
begin

insert into p.Employees(FirstName, LastName , Salary)
values (@FirstName, @LastName, @Salary)

end

execute  p.usAddEmployee 'Tarek' , 'Fysal' , 20000
go
-- part 2 :
-- Create a table EmployeeLog(Id, EmployeeId, Action, ActionDate).

-- create AFTER INSERT Trigger which Automatically log when a new employee is added.  

create table p.Employee_Logs
(
Id int identity (1,1) primary key ,
Employee_Id int,
Action varchar(50),
Action_Date DATETIME
)

go

CREATE TRIGGER p.Trigger_t
ON p.Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO p.Employee_Logs (Employee_Id, Action, Action_Date)
    SELECT Id, 'Insert', GETDATE()
    FROM inserted
END
go

EXEC p.usAddEmployee 'Ahmed','belal',10000
GO

SELECT * FROM p.Employee_Logs;
GO

 execute p.usGetAllEmployee