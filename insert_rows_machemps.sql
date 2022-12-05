USE [Port]
GO

ALTER PROCEDURE [dbo].[insert_rows_machemps] AS
BEGIN
	INSERT INTO MachineryEmployees
	SELECT MachineryID, EmployeeID, 'Other'
	FROM Machinery CROSS JOIN Employees 
END