USE [Port]
GO 

--Readuce la versiunea 4
CREATE PROCEDURE down_from_v4
AS
BEGIN
ALTER TABLE Visitor
DROP COLUMN VisitorCountry
END

EXEC down_from_v4