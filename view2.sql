-- View ce contine o comanda SELECT aplicata pe cel putin 2 tabele
USE [Port]
GO

CREATE VIEW View2 AS
	SELECT EmployeeName, MachineryUser 
	FROM Employees e INNER JOIN  MachineryEmployees me ON e.EmployeeID = me.EmployeeID
GO

SELECT * FROM View2;