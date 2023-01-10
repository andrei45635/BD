CREATE DATABASE Practic
GO

USE Practic
GO

CREATE TABLE Clients(
	ClientID INT NOT NULL PRIMARY KEY IDENTITY,
	ClientFirstName VARCHAR(50),
	ClientLastName VARCHAR(50),
	ClientGender VARCHAR(50),
	ClientBirthDate VARCHAR(50)
);

INSERT INTO Clients(ClientFirstName, ClientLastName, ClientGender, ClientBirthDate) 
VALUES ('Iacob', 'Andrei', 'Masculin', '09-07-2002')
INSERT INTO Clients(ClientFirstName, ClientLastName, ClientGender, ClientBirthDate) 
VALUES ('Festa', 'Robert', 'Masculin', '16-12-2002')
INSERT INTO Clients(ClientFirstName, ClientLastName, ClientGender, ClientBirthDate) 
VALUES ('Munteanu', 'Andrei', 'Masculin', '29-11-02')
INSERT INTO Clients(ClientFirstName, ClientLastName, ClientGender, ClientBirthDate) 
VALUES ('Soldan', 'Nicolae', 'Masculin', '08-09-2002')
INSERT INTO Clients(ClientFirstName, ClientLastName, ClientGender, ClientBirthDate) 
VALUES ('Vance', 'Alyx', 'Feminin', '09-07-2023')
INSERT INTO Clients(ClientFirstName, ClientLastName, ClientGender, ClientBirthDate) 
VALUES ('Mossman', 'Julia', 'Feminin', '23-04-2000')

SELECT * FROM Clients

CREATE TABLE Apartments(
	ApartmentID INT NOT NULL PRIMARY KEY IDENTITY,
	ApartmentNo INT,
	ApartmentFloor INT,
	ApartmentBlock INT,
	ApartmentBuilding INT,
	ApartmentStreet VARCHAR(50),
	ApartmentCity VARCHAR(50)
);

INSERT INTO Apartments(ApartmentNo, ApartmentFloor, ApartmentBlock, ApartmentBuilding, ApartmentStreet, ApartmentCity)
VALUES (18, 3, 2, 8, 'Melodiei 8', 'Galati')
INSERT INTO Apartments(ApartmentNo, ApartmentFloor, ApartmentBlock, ApartmentBuilding, ApartmentStreet, ApartmentCity)
VALUES (19, 1, 5, 8, 'Melodiei 8', 'Galati')
INSERT INTO Apartments(ApartmentNo, ApartmentFloor, ApartmentBlock, ApartmentBuilding, ApartmentStreet, ApartmentCity)
VALUES (22, 5, 1, 9, 'Siderurgistilor 9', 'Galati')
INSERT INTO Apartments(ApartmentNo, ApartmentFloor, ApartmentBlock, ApartmentBuilding, ApartmentStreet, ApartmentCity)
VALUES (14, 6, 7, 12, 'Ceva 12', 'SUA')
INSERT INTO Apartments(ApartmentNo, ApartmentFloor, ApartmentBlock, ApartmentBuilding, ApartmentStreet, ApartmentCity)
VALUES (42, 2, 4, 1, 'City 17', 'Bulgaria')
INSERT INTO Apartments(ApartmentNo, ApartmentFloor, ApartmentBlock, ApartmentBuilding, ApartmentStreet, ApartmentCity)
VALUES (53, 3, 3, 5, 'City 17', 'Bulgaria')

SELECT * FROM Apartments 
DELETE FROM Apartments WHERE ApartmentID = 2

CREATE TABLE Goods(
	GoodsID INT NOT NULL PRIMARY KEY IDENTITY,
	GoodsName VARCHAR(50),
	GoodsDescription VARCHAR(50),
	GoodsPrice FLOAT
);

INSERT INTO Goods(GoodsName, GoodsDescription, GoodsPrice) 
VALUES ('Consola', 'Vidya', 599)
INSERT INTO Goods(GoodsName, GoodsDescription, GoodsPrice) 
VALUES ('Bijuterie', 'Diamant', 29499)
INSERT INTO Goods(GoodsName, GoodsDescription, GoodsPrice) 
VALUES ('Carte', 'Roman', 59)
INSERT INTO Goods(GoodsName, GoodsDescription, GoodsPrice) 
VALUES ('Electrocasnice', 'Televizor', 1999)
INSERT INTO Goods(GoodsName, GoodsDescription, GoodsPrice) 
VALUES ('Electrocasnice', 'Masina de spalat', 999)
INSERT INTO Goods(GoodsName, GoodsDescription, GoodsPrice) 
VALUES ('Mobila', 'Dulap', 699)

SELECT * FROM Goods

CREATE TABLE Rate(
	RateID INT NOT NULL PRIMARY KEY IDENTITY,
	RateNo INT,
	RateValue FLOAT,
	RateDataScadenta VARCHAR(50),
	ClientID INT NOT NULL FOREIGN KEY REFERENCES Clients(ClientID),
	ApartmentID INT NOT NULL FOREIGN KEY REFERENCES Apartments(ApartmentID)
);

INSERT INTO Rate(RateNo, RateValue, RateDataScadenta, ClientID, ApartmentID) 
VALUES (6, 299, '29-09-2023', 1, 1)
INSERT INTO Rate(RateNo, RateValue, RateDataScadenta, ClientID, ApartmentID) 
VALUES (12, 699, '29-02-2023', 2, 4)
INSERT INTO Rate(RateNo, RateValue, RateDataScadenta, ClientID, ApartmentID) 
VALUES (3, 399, '29-03-2023', 4, 3)
INSERT INTO Rate(RateNo, RateValue, RateDataScadenta, ClientID, ApartmentID) 
VALUES (2, 2999, '29-05-2023', 6, 7)
INSERT INTO Rate(RateNo, RateValue, RateDataScadenta, ClientID, ApartmentID) 
VALUES (4, 99, '29-10-2025', 3, 5)
INSERT INTO Rate(RateNo, RateValue, RateDataScadenta, ClientID, ApartmentID) 
VALUES (24, 1100, '19-09-2024', 5, 6)
INSERT INTO Rate(RateNo, RateValue, RateDataScadenta, ClientID, ApartmentID) 
VALUES (1, 2999, '18-02-2025', 5, 6)

SELECT * FROM Rate

CREATE TABLE AptGoods(
	GoodsID INT NOT NULL FOREIGN KEY REFERENCES Goods(GoodsID),
	ApartmentID INT NOT NULL FOREIGN KEY REFERENCES Apartments(ApartmentID),
	AptGoodsAcquisitionDate VARCHAR(50),
	AptGoodsQuantity FLOAT,
	AptGoodsPrice FLOAT,
	CONSTRAINT pk_AptGoods PRIMARY KEY (GoodsID, ApartmentID)
);

INSERT INTO AptGoods(GoodsID, ApartmentID, AptGoodsAcquisitionDate, AptGoodsQuantity, AptGoodsPrice)
VALUES (1, 1, '19-09-2020', 2, 2499)
INSERT INTO AptGoods(GoodsID, ApartmentID, AptGoodsAcquisitionDate, AptGoodsQuantity, AptGoodsPrice)
VALUES (2, 3, '19-09-2021', 1, 29499)
INSERT INTO AptGoods(GoodsID, ApartmentID, AptGoodsAcquisitionDate, AptGoodsQuantity, AptGoodsPrice)
VALUES (3, 5, '07-08-2021', 5, 299)
INSERT INTO AptGoods(GoodsID, ApartmentID, AptGoodsAcquisitionDate, AptGoodsQuantity, AptGoodsPrice)
VALUES (4, 6, '19-09-2018', 2, 3999)
INSERT INTO AptGoods(GoodsID, ApartmentID, AptGoodsAcquisitionDate, AptGoodsQuantity, AptGoodsPrice)
VALUES (5, 7, '21-05-2022', 1, 999)
INSERT INTO AptGoods(GoodsID, ApartmentID, AptGoodsAcquisitionDate, AptGoodsQuantity, AptGoodsPrice)
VALUES (6, 4, '23-03-2018', 2, 1399)

SELECT * FROM AptGoods

GO
CREATE OR ALTER PROCEDURE UPSERT 
	@goods VARCHAR(100),
	@apartament INT,
	@acquisitionDate VARCHAR(50),
	@quantity FLOAT,
	@price FLOAT
AS
BEGIN 
	DECLARE @aptID INT
	DECLARE @goodsID INT

	SELECT TOP 1 @aptID = ApartmentID FROM Apartments WHERE Apartments.ApartmentNo = @apartament
	SELECT TOP 1 @goodsID = GoodsID FROM Goods WHERE Goods.GoodsName = @goods

	IF @aptID IS NULL OR @goodsID IS NULL
		THROW 50001, 'Apartament sau bun invalid!', 1
	ELSE IF (EXISTS (SELECT * FROM AptGoods WHERE ApartmentID = @aptID AND GoodsID = @goodsID))
		UPDATE AptGoods SET AptGoodsAcquisitionDate = @acquisitionDate, AptGoodsQuantity = @quantity, AptGoodsPrice = @price WHERE ApartmentID = @aptID AND GoodsID = @goodsID
	ELSE 
		INSERT INTO AptGoods(GoodsID, ApartmentID, AptGoodsAcquisitionDate, AptGoodsQuantity, AptGoodsPrice) VALUES (@aptID, @goodsID, @acquisitionDate, @quantity, @price)
END
GO

SELECT * FROM AptGoods
SELECT * FROM Goods
SELECT * FROM Apartments
EXEC UPSERT 'Carte', 19, '10-01-2023', 1, 224524
SELECT * FROM AptGoods

GO
CREATE OR ALTER FUNCTION rateClienti()
RETURNS TABLE
RETURN 
	SELECT c.ClientFirstName, c.ClientLastName FROM Clients c
	INNER JOIN Rate r ON r.ClientID = c.ClientID
	WHERE r.RateValue = (SELECT MAX(r.RateValue) FROM Rate r)
GO

SELECT * FROM rateClienti()
SELECT * FROM Clients
SELECT * FROM Rate