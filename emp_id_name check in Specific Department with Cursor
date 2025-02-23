declare @EmployeeID int;
declare @EmployeeName varchar(100);

declare EmployeeCursor Cursor for
select employee_id ,first_name
from employees
where department_id = 90;

open EmployeeCursor ;

FETCH NEXT FROM EmployeeCursor into 
@EmployeeID,@EmployeeName;

while @@FETCH_STATUS = 0
begin 
	print 'Employee ID:' + cast(@EmployeeID as nvarchar)+', Name: ' +@EmployeeName;


FETCH NEXT FROM EmployeeCursor INTO 
@EmployeeID, @EmployeeName;
END;

CLOSE EmployeeCursor;

Deallocate EmployeeCursor;


select * from employees;
