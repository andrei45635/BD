USE [Port]
GO

ALTER PROCEDURE main_test (@table VARCHAR(30)) AS 
DECLARE @date_start DATETIME
DECLARE @date_mid DATETIME
DECLARE @date_end DATETIME
DECLARE @desc VARCHAR(100)
DECLARE @id1 INT

BEGIN
	SET NOCOUNT ON;

	IF ISNUMERIC(@table) = 1
		BEGIN
			PRINT('Tabela trebuie sa fie string!')
			RETURN 1
		END

	IF @table = 'Machinery'
		BEGIN
			SET @date_start = GETDATE()
			EXEC delete_table_machs
			EXEC insert_rows_machs
			SET @date_mid = GETDATE()
			EXEC select_view View1
			SET @date_end = GETDATE()
			INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test pe Machinery, inserare 1000 elemente si stergere + view', @date_start, @date_end)
			SELECT TOP 1 @id1 = TestRunID FROM TestRuns ORDER BY NEWID()
			INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 1, @date_start, @date_mid)
			INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@id1, 1, @date_mid, @date_end)
		END

	IF @table = 'Employees'
		BEGIN
			SET @date_start = GETDATE()
			EXEC delete_table_emps
			EXEC insert_rows_emps
			SET @date_mid = GETDATE()
			SELECT * FROM View21
			--EXEC select_view View2 
			SET @date_end = GETDATE()
			INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test pe Employees, inserare 1000 elemente si stergere + view', @date_start, @date_end)
			SELECT TOP 1 @id1 = TestRunID FROM TestRuns ORDER BY NEWID()
			INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 2, @date_start, @date_mid)
			INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@id1, 2, @date_mid, @date_end)
		END

	IF @table = 'MachineryEmployees'
		BEGIN
			SET @date_start = GETDATE()
			EXEC delete_table_machemps
			EXEC insert_rows_machemps
			SET @date_mid = GETDATE()
			EXEC select_view View3
			SET @date_end = GETDATE()
			INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Test pe MachineryEmployees, inserare 1000 elemente si stergere + view', @date_start, @date_end)
			SELECT TOP 1 @id1 = TestRunID FROM TestRuns ORDER BY NEWID()
			INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 3, @date_start, @date_mid)
			INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@id1, 3, @date_mid, @date_end)
		END
END

SELECT * FROM WarehouseEmployees
SELECT * FROM MachineryEmployees
SELECT * FROM Machinery
SELECT * FROM Employees

DELETE FROM Employees
DBCC CHECKIDENT ('Employees', RESEED, 0)
GO
DELETE FROM Machinery
DBCC CHECKIDENT ('Machinery', RESEED, 0)
GO

SELECT * FROM View1;
SELECT * FROM View2;
SELECT * FROM View3;

DELETE FROM WarehouseEmployees
DELETE FROM MachineryEmployees
DELETE FROM Machinery
DELETE FROM Employees

EXEC main_test Machinery
EXEC main_test Employees
EXEC main_test MachineryEmployees

SELECT * FROM Tables
SELECT * FROM TestTables
SELECT * FROM Tests
SELECT * FROM TestViews
SELECT * FROM Views

DELETE FROM Tables
DELETE FROM TestTables
DELETE FROM Tests
DELETE FROM TestViews
DELETE FROM Views

SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
SELECT * FROM TestRuns

DELETE FROM TestRunTables
DELETE FROM TestRunViews
DELETE FROM TestRuns

DROP TABLE TestRunViews
DROP TABLE TestRunTables
DROP TABLE TestRuns
DROP TABLE TestTables
DROP TABLE TestViews
DROP TABLE Tests
DROP TABLE Tables
DROP TABLE Views