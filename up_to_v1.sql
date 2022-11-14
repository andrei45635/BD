USE [Port]
GO

--Modifica tabela Sailors: coloana SailorTimeAway INT -> SailorTimeAway FLOAT NOT NULL
CREATE PROCEDURE up_to_v1
AS
BEGIN
ALTER TABLE Sailors
ALTER COLUMN SailorTimeAway FLOAT NOT NULL
END

EXEC up_to_v1
