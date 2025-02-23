CREATE PROCEDURE EMP_INFO 
@DeptId int
As
Begin
	Declare
		@EmpName varchar(50),
		@EmpDept int,
		@EmpHiredate date,
		@EmpSalary int;

	Declare emp_info_cur2 Cursor
	For 
	Select first_name+' '+last_name as Name, department_id, hire_date, salary
	From employees
	where department_id = @DeptId;

	open emp_info_cur2;

	Fetch next from emp_info_cur2 into @EmpName,@EmpDept,@EmpHiredate,@EmpSalary;

	while 
		@@FETCH_STATUS =0
	begin
		print 'Employee Name:'+ @EmpName +', '+'Department ID: '+ cast(@EmpDept as varchar) + ', '+
		'Joining Date: '+ cast(@EmpHiredate as varchar) + ', ' + 'Salary: ' + cast(@EmpSalary as varchar);

		Fetch next from emp_info_cur2 into @EmpName,@EmpDept,@EmpHiredate,@EmpSalary;
	end;

	close emp_info_cur2;
	Deallocate emp_info_cur2;

END;

exec EMP_INFO @DeptId=100;
