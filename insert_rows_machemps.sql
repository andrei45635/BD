USE [Port]
GO

CREATE PROCEDURE [dbo].[insert_rows_machemps] AS
BEGIN
	SELECT MachineryID, EmployeeID
	INTO MachineryEmployees4
	FROM Machinery CROSS JOIN Employees
END