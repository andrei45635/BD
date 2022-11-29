USE [Port]
GO

ALTER PROCEDURE insert_rows AS
BEGIN
DECLARE @noOfRows INT
DECLARE @n INT
DECLARE @t VARCHAR(30)
DECLARE @fk1 INT 
DECLARE @machuser VARCHAR(50)
SET @machuser='Anon'

--Inserting Employees--
SELECT TOP 1 @fk1 = ManagerID FROM [dbo].Managers ORDER BY NEWID()

SET @n=1
WHILE @n < @noOfRows
	BEGIN
		SET @t = 'Employee' + CONVERT(VARCHAR(5), @n)
		INSERT INTO Employees(EmployeeID, EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (@n, 1400, 300, 22, @fk1, @t)
		SET @n=@n+1
	END

--Inserting Machineries--
SELECT TOP 1 @noOfRows = NoOfRows FROM [dbo].TestTables
SET @n=1

WHILE @n < @noOfRows
	BEGIN 
		SET @t = 'Machinery' + CONVERT(VARCHAR(5), @n)
		INSERT INTO Machinery(MachineryID, MachineryType, MachineryManufacturer) VALUES (@n, 'Other', @t)
		SET @n=@n+1
	END

--Inserting into MachineryEmployees
SELECT MachineryID, EmployeeID
INTO MachineryEmployees4
FROM Machinery CROSS JOIN Employees
END