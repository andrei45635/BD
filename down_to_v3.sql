USE [Port]
GO 

--Readuce la versiunea 3
CREATE PROCEDURE down_from_v3
AS
BEGIN
DROP TABLE Visitor
END

EXEC down_from_v3
