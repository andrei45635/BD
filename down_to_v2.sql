USE [Port]
GO 

--Readuce la versiunea 3
CREATE PROCEDURE [dbo].[down_from_v2]
AS
BEGIN
DROP TABLE Visitor
PRINT('Am sters tabela Visitor')
END

EXEC down_from_v2
