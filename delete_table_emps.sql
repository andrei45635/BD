USE [Port]
GO

CREATE PROCEDURE delete_table_emps AS
BEGIN
	DELETE FROM Employees;
END
