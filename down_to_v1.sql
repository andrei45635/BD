USE [Port]
GO

--Readuce la versiunea 1
CREATE PROCEDURE down_from_v1
AS
BEGIN 
ALTER TABLE Sailors 
ALTER COLUMN SailorTimeAway INT
END

EXEC down_from_v1