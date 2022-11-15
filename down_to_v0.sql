USE [Port]
GO

--Readuce la versiunea 1
CREATE PROCEDURE [dbo].[down_from_v0]
AS
BEGIN 
ALTER TABLE Sailors 
ALTER COLUMN SailorTimeAway INT
PRINT('Am readus SailorTimeAway la INT')
END

EXEC down_from_v0