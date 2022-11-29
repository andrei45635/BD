USE [Port]
GO

ALTER PROCEDURE main_test AS
DECLARE @date_start DATETIME
DECLARE @date_mid DATETIME
DECLARE @date_end DATETIME

BEGIN
SET NOCOUNT ON;

SET @date_start=GETDATE()
EXEC delete_tables
EXEC insert_rows

SET @date_mid=GETDATE()
EXEC select_views

SET @date_end=GETDATE()

PRINT('\n')
PRINT DATEDIFF(second, @date_end, @date_start)
PRINT('\n')

DECLARE @desc VARCHAR(100)
SET @desc = 'TestRun' + CONVERT(VARCHAR(10), (SELECT MAX(TestRunID) FROM TestRuns)) + ' delete, insert 3 rows and select all views'
INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES (@desc, @date_start, @date_end)
SELECT * FROM TestRuns
DECLARE @lastTestRunID INT 
SET @lastTestRunID = (SELECT MAX(TestRunID) FROM TestRuns);
INSERT INTO TestRunTables VALUES (3, 1, @date_start, @date_end)
INSERT INTO TestRunViews VALUES (3, 1, @date_mid, @date_end)
--INSERT INTO TestRunTables VALUES (@lastTestRunID, 1, @date_start, @date_end)
--INSERT INTO TestRunTables VALUES (@lastTestRunID, 2, @date_start, @date_end)
--INSERT INTO TestRunTables VALUES (@lastTestRunID, 3, @date_start, @date_end)
--INSERT INTO TestRunViews VALUES (@lastTestRunID, 1, @date_mid, @date_end)
--INSERT INTO TestRunViews VALUES (@lastTestRunID, 2, @date_mid, @date_end)
--INSERT INTO TestRunViews VALUES (@lastTestRunID, 3, @date_mid, @date_end)
END
SELECT * FROM MachineryEmployees
SELECT * FROM Tables
EXEC main_test