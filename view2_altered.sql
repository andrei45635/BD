-- View ce contine o comanda SELECT aplicata pe cel putin 2 tabele
USE [Port]
GO

CREATE VIEW View21 AS
	SELECT EmployeeName, ManagerName
	FROM Employees e INNER JOIN  Managers m ON e.ManagerID = m.ManagerID
GO

SELECT * FROM View21;