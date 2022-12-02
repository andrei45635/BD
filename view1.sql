-- View ce contine o comanda SELECT pe o tabela
USE [Port]
GO

CREATE VIEW View1 AS
	SELECT MachineryType, MachineryManufacturer
	FROM Machinery 
GO

SELECT * FROM View1;