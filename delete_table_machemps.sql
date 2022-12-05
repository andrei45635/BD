USE [Port]
GO

ALTER PROCEDURE delete_table_machemps AS
BEGIN
	DELETE FROM WarehouseEmployees;
	DELETE FROM MachineryEmployees;
END