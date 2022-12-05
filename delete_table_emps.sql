USE [Port]
GO

ALTER PROCEDURE delete_table_emps AS
BEGIN
	--DELETE FROM WarehouseEmployees;
	--DELETE FROM MachineryEmployees;
	DELETE FROM Employees;
END
