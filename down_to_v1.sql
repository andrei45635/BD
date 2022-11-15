USE [Port]
GO 

--Readuce la versiunea 2
CREATE PROCEDURE [dbo].[down_from_v1]
AS
BEGIN 
ALTER TABLE Sailors 
DROP CONSTRAINT df_name
PRINT('Nu mai avem constraint DEFAULT Anon la SailorName')
END

EXEC down_from_v1