USE [Port]
GO 

--Adauga coloana VisitorName in tabela Visitor
ALTER PROCEDURE [dbo].[up_to_v4]
AS
BEGIN
ALTER TABLE Visitor
ADD VisitorCountry VARCHAR(50)
PRINT('Adaugare coloana VisitorName')
END

EXEC up_to_v4