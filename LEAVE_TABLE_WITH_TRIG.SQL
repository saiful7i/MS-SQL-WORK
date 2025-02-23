CREATE TABLE Leave (
    leave_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    leave_type VARCHAR(20) NOT NULL CHECK (leave_type IN ('Yearly', 'Casual', 'Sick')),
    leave_start_date DATE NOT NULL,
    leave_end_date DATE NOT NULL,
    leave_days INT NOT NULL CHECK (leave_days > 0),
    CONSTRAINT FK_Leave_Employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
GO


CREATE TRIGGER trg_CheckYearlyLeave
ON Leave
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @employee_id INT;
    DECLARE @yearly_leave_days INT;

    SELECT @employee_id = employee_id FROM inserted;
    SELECT @yearly_leave_days = SUM(leave_days) 
    FROM Leave 
    WHERE employee_id = @employee_id 
      AND leave_type = 'Yearly' 
      AND YEAR(leave_start_date) = YEAR(GETDATE());

    IF @yearly_leave_days > 20
    BEGIN
        RAISERROR('Yearly leave limit exceeded (20 days per year).', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO




CREATE TRIGGER trg_CheckCasualLeave
ON Leave
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @employee_id INT;
    DECLARE @casual_leave_days INT;
    DECLARE @casual_leave_days_this_month INT;

    SELECT @employee_id = employee_id FROM inserted;
    SELECT @casual_leave_days = SUM(leave_days) 
    FROM Leave 
    WHERE employee_id = @employee_id 
      AND leave_type = 'Casual' 
      AND YEAR(leave_start_date) = YEAR(GETDATE());

    SELECT @casual_leave_days_this_month = SUM(leave_days) 
    FROM Leave 
    WHERE employee_id = @employee_id 
      AND leave_type = 'Casual' 
      AND YEAR(leave_start_date) = YEAR(GETDATE())
      AND MONTH(leave_start_date) = MONTH(GETDATE());

    IF @casual_leave_days > 20
    BEGIN
        RAISERROR('Casual leave limit exceeded (20 days per year).', 16, 1);
        ROLLBACK TRANSACTION;
    END

    IF @casual_leave_days_this_month > 3
    BEGIN
        RAISERROR('Casual leave limit exceeded (3 days per month).', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO








CREATE TRIGGER trg_CheckSickLeave
ON Leave
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @employee_id INT;
    DECLARE @sick_leave_days INT;

    SELECT @employee_id = employee_id FROM inserted;
    SELECT @sick_leave_days = SUM(leave_days) 
    FROM Leave 
    WHERE employee_id = @employee_id 
      AND leave_type = 'Sick' 
      AND YEAR(leave_start_date) = YEAR(GETDATE());

    IF @sick_leave_days > 10
    BEGIN
        RAISERROR('Sick leave limit exceeded (10 days per year).', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
