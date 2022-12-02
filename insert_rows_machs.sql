USE [Port]
GO

ALTER PROCEDURE [dbo].[insert_rows_machs] AS
BEGIN
DECLARE @noOfRows INT
DECLARE @n INT
DECLARE @t VARCHAR(30)

SET IDENTITY_INSERT Machinery ON;

SELECT TOP 1 @noOfRows = NoOfRows FROM [dbo].TestTables
SET @n=6

WHILE @n < @noOfRows
	BEGIN 
		SET @t = 'Machinery' + CONVERT(VARCHAR(5), @n)
		INSERT INTO Machinery(MachineryID, MachineryType, MachineryManufacturer) VALUES (@n, 'Other', @t)
		SET @n=@n+1
	END
END