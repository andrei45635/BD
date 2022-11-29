USE [Port]
GO

CREATE PROCEDURE select_views AS
DECLARE @n INT
DECLARE @t VARCHAR(50)
BEGIN 
SET @n=1
WHILE @n<=3
	BEGIN
		SET @t = 'View' + CONVERT(VARCHAR(5), @n)
		EXEC select_view @t
		SET @n=@n+1
	END
END