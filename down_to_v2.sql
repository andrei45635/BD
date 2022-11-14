USE [Port]
GO 

--Readuce la versiunea 2
CREATE PROCEDURE down_from_v2
AS
BEGIN 
ALTER TABLE Sailors 
DROP CONSTRAINT df_name
END

EXEC down_from_v2