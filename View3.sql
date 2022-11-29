-- View ce contine o comanda SELECT aplicata pe cel putin 2 tabele avand GROUP BY
USE [Port]
GO

CREATE VIEW View3 AS
	SELECT EmployeeName, MachineryManufacturer 
	FROM MachineryEmployees me INNER JOIN Employees e ON me.EmployeeID = e.EmployeeID
							   INNER JOIN Machinery m ON me.MachineryID = m.MachineryID
	GROUP BY EmployeeName, MachineryManufacturer
GO