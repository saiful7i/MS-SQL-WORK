--Filter Employees by Department
select * from employees
where department_id = (select department_id from departments
						where department_name = 'Sales');

--Count Employees in Each Department
select d.department_name, count(e.employee_id)
from employees e  join departments d
on e.department_id = d.department_id
group by d.department_name,e.department_id;



--List Employees with Their Department Names
select e.employee_id, e.first_name +' '+e.last_name as Name,d.department_name
from employees e join departments d
on e.department_id=d.department_id
;

--Find the Highest Salary in Each Department
select d.department_name, max(salary)
from employees e join departments d 
on e.department_id = d.department_id
group by e.department_id, d.department_name;


--List Employees Earning More Than Their Department Average
select employee_id,last_name,salary,department_id
from employees e
where e.salary > (select avg(salary)
				from employees d
				where e.department_id=d.department_id);


--Find Employees Without a Manager
select * 
from employees
where manager_id is null;


--Find the Second Highest Salary
select max(salary) 
from employees
where salary <(select max(salary)
					from employees);


--List Employees with Their Manager's Name
select e.employee_id,e.first_name +' '+e.last_name as Name, m.last_name as Maneger
from employees e left join employees m
on e.manager_id=m.employee_id;


--Find Employees Hired in the Last 6 Months
select employee_id,last_name,hire_date
from employees
where hire_date >= DATEADD(YEAR, -25, GETDATE());

--Calculate Employee Tenure
select employee_id,last_name,
DATEDIFF(year,hire_date,GETDATE()) AS TenureINYears
from employees;


--Find Departments with More Than 10 Employees
select e.department_id,d.department_name,count(e.employee_id)
from employees e join departments d
on e.department_id=d.department_id
group by e.department_id,d.department_name
having count(e.employee_id) >= 10;
