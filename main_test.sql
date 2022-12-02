USE [Port]
GO

ALTER PROCEDURE main_test AS
DECLARE @desc VARCHAR(100)
DECLARE @id1 INT
DECLARE @date_start DATETIME
DECLARE @date_end DATETIME

BEGIN
	SET NOCOUNT ON;

	--inserting machineries
	SET @date_start=GETDATE()
	EXEC insert_rows_machs
	SET @date_end = GETDATE()
	SET @id1 = @@IDENTITY
	SET @desc = 'inserted in table with 1 primary key'
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES (@desc, @date_start, @date_end)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 1, @date_start, @date_end)

	--inserting employees
	SET @date_start = GETDATE()
	EXEC insert_rows_emps
	SET @date_end = GETDATE()
	SET @id1 = @@IDENTITY
	SET @desc = 'inserted in table with 1 primary key and 1 foreign key'
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES (@desc, @date_start, @date_end)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 2, @date_start, @date_end)

	--inserting machinery employees
	SET @date_start = GETDATE()
	EXEC insert_rows_machemps
	SET @date_end = GETDATE()
	SET @id1 = @@IDENTITY
	SET @desc = 'inserted in complex table'
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES (@desc, @date_start, @date_end)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 3, @date_start, @date_end)

	--view 1
	SET @date_start = GETDATE()
	SELECT * FROM View1
	SET @date_end=GETDATE()
	PRINT @id1
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@id1, 1, @date_start, @date_end)

	--view 2
	SET @date_start = GETDATE()
	SELECT * FROM View2
	SET @date_end=GETDATE()
	PRINT @id1
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@id1, 2, @date_start, @date_end)

	--view 3
	SET @date_start = GETDATE()
	SELECT * FROM View3
	SET @date_end=GETDATE()
	PRINT @id1
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@id1, 3, @date_start, @date_end)

	--delete from the complex table
	SET @date_start = GETDATE()
	EXEC delete_table_machemps
	SET @date_end = GETDATE()
	SET @desc = 'deleted from the complex table'
	SET @id1 = @@IDENTITY
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES (@desc, @date_start, @date_end)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 3, @date_start, @date_end)

	--delete machineries
	SET @date_start = GETDATE()
	EXEC delete_table_machs
	SET @date_end = GETDATE()
	SET @desc = 'deleted machineries'
	SET @id1 = @@IDENTITY
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES (@desc, @date_start, @date_end)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 1, @date_start, @date_end)

	--delete employees
	SET @date_start = GETDATE()
	EXEC delete_table_emps
	SET @date_end = GETDATE()
	SET @desc = 'deleted employees'
	SET @id1 = @@IDENTITY
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES (@desc, @date_start, @date_end)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@id1, 2, @date_start, @date_end)

	UPDATE TestRuns SET EndAt = @date_end WHERE TestRunID = @id1
END

SELECT * FROM WarehouseEmployees
SELECT * FROM MachineryEmployees
SELECT * FROM Machinery
SELECT * FROM Employees

DELETE FROM Machinery WHERE MachineryID > 5
DROP TABLE MachineryEmployees4

EXEC main_test

SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
SELECT * FROM TestRuns

DELETE FROM TestRunTables
DELETE FROM TestRunViews
DELETE FROM TestRuns