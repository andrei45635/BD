USE [Port]
GO

ALTER PROCEDURE delete_table_machemps AS
BEGIN
	DELETE FROM WarehouseEmployees;
	--DELETE FROM WarehouseEmployees4;
	DELETE FROM MachineryEmployees;
END