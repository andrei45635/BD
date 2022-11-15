USE [Port]
GO 

--Adauga tabela Visitor
ALTER PROCEDURE [dbo].[up_to_v3]
AS
BEGIN
CREATE TABLE Visitor(
	VisitorID INT NOT NULL PRIMARY KEY IDENTITY,
	VisitorName VARCHAR(50),
	VisitorAge INT CHECK(VisitorAge >= 5),
	SailorID INT NOT NULL
);
PRINT('Am creat tabela Visitor')
END

EXEC up_to_v3