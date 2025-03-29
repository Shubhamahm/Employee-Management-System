CREATE TABLE college.Employee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    HireDate DATE NOT NULL,
    JobTitle VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2)
);

create table college.Department(
	DepartmentID int not null primary key auto_increment,
    DepartmentName varchar(100) not null unique,
    ManagerID int
    );
    
 create table college.Payroll(
	PayrollID int not null primary key auto_increment,
    EmployeeID int,
    BasicSalary decimal (10,2) not null,
    Bonus decimal (10,2),
    Deductions decimal(10,2),
--     NetSalary as (BasicSalary+Bonus-Deductions) persistent,
    PayDate Date not null
    );   
    
    create table college.Attendance(
		AttendanceID int primary key auto_increment,
        EmployeeID int ,
        AttendanceDate date,
        Status enum('Present','Absent','Leave') not null
    );
    
ALTER TABLE college.Employee
ADD CONSTRAINT fk_dept FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);

alter table college.Department
add constraint fk_emp foreign key (EmployeeID) references Employee(EmployeeID);  

alter table college.Payroll
add constraint fk_pay foreign key (EmployeeID) references Employee(EmployeeID);

alter table college.attendance
add constraint fk_atte foreign key (EmployeeID) references Employee(EmployeeID);

alter table college.Department
rename column ManagerID to EmployeeID;

select* from college.Department; 
select* from college.payroll; 
select* from college.attendance; 
select* from college.employee; 

SET SQL_SAFE_UPDATES = 0;

UPDATE college.department 
SET EmployeeID = NULL;

SET SQL_SAFE_UPDATES = 1;


select employee.EmployeeID, FirstName, LastName, DepartmentName from college.employee
right join college.Department on department.EmployeeID=employee.EmployeeID;

select employee.EmployeeID, FirstName, LastName, PayrollID, BasicSalary from college.employee
join college.payroll on payroll.EmployeeID=employee.EmployeeID;

select FirstName, LastName, employee.EmployeeID, Status,count(AttendanceID) from college.Employee
join college.attendance on attendance.EmployeeID=employee.EmployeeID
where Status='Present'
group by employee.EmployeeID;


ALTER TABLE college.Department DROP FOREIGN KEY fk_emp;

UPDATE college.Department d
JOIN college.Employee e ON e.DepartmentID = d.DepartmentID
SET d.EmployeeID = e.EmployeeID
WHERE d.EmployeeID IS NULL;

-- Find Employees Who Have a Salary Greater Than 50,000
select FirstName,LastName,Salary from college.Employee
where salary>50000;

select count(Employee.EmployeeID),DepartmentName from college.Employee -- Count total employee in each department
join college.Department on Department.EmployeeID= Employee.EmployeeID
group by Department.DepartmentName;

select employeeID from college.department -- department with no employees  
where employeeID is null; 

-- Get Total Payroll Expenses for the Current Month
select sum(BasicSalary) as TotalSalary from college.payroll
where month(Paydate)= month(current_date()); 

-- Get Employees Who Have Not Received Their Payroll in the Last Month
select Employee.EmployeeID, FirstName, LastName from college.employee
join college.payroll on employee.employeeID=payroll.employeeID
where month(paydate)=month(current_date)-1 and PayrollID is null;

-- Find Employees Who Have Taken Leave More Than Twice This Month-- 
select employee.employeeID, FirstName, LastName, status, count(AttendanceID)as LeaveCount from college.employee
join college.attendance on employee.employeeID= attendance.employeeID
where Status='Leave' and month(attendanceDate)=month(current_date())
group by attendance.EmployeeID
having LeaveCount>=2;