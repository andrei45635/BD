USE [Port]
GO

ALTER PROCEDURE [dbo].[insert_rows_emps] AS
BEGIN
DECLARE @noOfRows INT
DECLARE @n INT
DECLARE @t VARCHAR(30)
DECLARE @fk1 INT 

SET IDENTITY_INSERT Employees ON;

--Inserting Employees--
SELECT TOP 1 @fk1 = ManagerID FROM [dbo].Managers ORDER BY NEWID()
SELECT TOP 1 @noOfRows = NoOfRows FROM [dbo].TestTables

SET @n=8
WHILE @n < @noOfRows
	BEGIN
		SET @t = 'Employee' + CONVERT(VARCHAR(5), @n)
		INSERT INTO Employees(EmployeeID, EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (@n, 1400, 300, 22, @fk1, @t)
		SET @n=@n+1
	END
END