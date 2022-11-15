USE [Port]
GO

--Modifica tabela Sailors: coloana SailorTimeAway INT -> SailorTimeAway FLOAT NOT NULL
ALTER PROCEDURE [dbo].[up_to_v1]
AS
BEGIN
ALTER TABLE Sailors
ALTER COLUMN SailorTimeAway FLOAT NOT NULL
PRINT('SailorTimeAway INT -> FLOAT')
END

EXEC up_to_v1
