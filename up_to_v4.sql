USE [Port]
GO 

--Adauga coloana VisitorName in tabela Visitor
CREATE PROCEDURE up_to_v4
AS
BEGIN
ALTER TABLE Visitor
ADD VisitorCountry VARCHAR(50)
END

EXEC up_to_v4