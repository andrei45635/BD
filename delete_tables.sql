USE [Port]
GO

ALTER PROCEDURE delete_tables AS
BEGIN 
	DELETE FROM WarehouseEmployees;
	DELETE FROM MachineryEmployees;
	DELETE FROM Machinery;
	DELETE FROM Employees;
END