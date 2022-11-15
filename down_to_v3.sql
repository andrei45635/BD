USE [Port]
GO 

--Readuce la versiunea 4
CREATE PROCEDURE [dbo].[down_from_v3]
AS
BEGIN
ALTER TABLE Visitor
DROP COLUMN VisitorCountry
PRINT('Visitor nu mai are tara')
END

EXEC down_from_v3