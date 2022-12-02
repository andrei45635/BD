USE [Port]
GO

CREATE PROCEDURE delete_table_machs AS
BEGIN
	DELETE FROM Machinery;
END