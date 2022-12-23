CREATE DATABASE TrenuriStatii
GO

USE TrenuriStatii
GO

CREATE TABLE TrainTypes(
	TrainTypeID INT NOT NULL PRIMARY KEY IDENTITY,
	TrainTypeDescr VARCHAR(100)
);

CREATE TABLE Trains(
	TrainID INT NOT NULL PRIMARY KEY IDENTITY,
	TrainName VARCHAR(50),
	TrainTypeID INT NOT NULL FOREIGN KEY REFERENCES TrainTypes(TrainTypeID)
);

CREATE TABLE TrainRoutes(
	RouteID INT NOT NULL PRIMARY KEY IDENTITY,
	RouteName VARCHAR(50),
	TrainID INT NOT NULL FOREIGN KEY REFERENCES Trains(TrainID)
);

CREATE TABLE TrainStations(
	StationID INT NOT NULL PRIMARY KEY IDENTITY,
	StationName VARCHAR(50)
);

CREATE TABLE TrainStationRoutes(
	StationID INT NOT NULL FOREIGN KEY REFERENCES TrainStations(StationID),
	RouteID INT NOT NULL FOREIGN KEY REFERENCES TrainRoutes(RouteID),
	Arrivals TIME,
	Departures TIME,
	CONSTRAINT PK_TrainRouteStations PRIMARY KEY (StationID, RouteID)
);

INSERT INTO TrainTypes(TrainTypeDescr) VALUES ('InterRegio')
INSERT INTO TrainTypes(TrainTypeDescr) VALUES ('Marfar')
INSERT INTO TrainTypes(TrainTypeDescr) VALUES ('Toy')
INSERT INTO TrainTypes(TrainTypeDescr) VALUES ('Cu abur')
INSERT INTO TrainTypes(TrainTypeDescr) VALUES ('Diesel')
INSERT INTO TrainTypes(TrainTypeDescr) VALUES ('TGV')

SELECT * FROM TrainTypes

INSERT INTO Trains(TrainName, TrainTypeID) VALUES ('Thomas', 3)
INSERT INTO Trains(TrainName, TrainTypeID) VALUES ('Edward', 1)
INSERT INTO Trains(TrainName, TrainTypeID) VALUES ('Henry', 4)
INSERT INTO Trains(TrainName, TrainTypeID) VALUES ('Gordon', 5)
INSERT INTO Trains(TrainName, TrainTypeID) VALUES ('James', 6)
INSERT INTO Trains(TrainName, TrainTypeID) VALUES ('Toby', 2)

SELECT * FROM Trains

INSERT INTO TrainRoutes(RouteName, TrainID) VALUES ('Galati - Cluj', 1)
INSERT INTO TrainRoutes(RouteName, TrainID) VALUES ('Cluj - Bucuresti', 4)
INSERT INTO TrainRoutes(RouteName, TrainID) VALUES ('Galati - Brasov', 3)
INSERT INTO TrainRoutes(RouteName, TrainID) VALUES ('Cluj - Brasov', 5)
INSERT INTO TrainRoutes(RouteName, TrainID) VALUES ('Turda - Debrecen', 6)
INSERT INTO TrainRoutes(RouteName, TrainID) VALUES ('Oradea - Budapesta', 2)

SELECT * FROM TrainRoutes

INSERT INTO TrainStations(StationName) VALUES ('Gara de Nord')
INSERT INTO TrainStations(StationName) VALUES ('Gara Centrala Cluj')
INSERT INTO TrainStations(StationName) VALUES ('Gara Galati')
INSERT INTO TrainStations(StationName) VALUES ('Bucuresti Baneasa')
INSERT INTO TrainStations(StationName) VALUES ('Gara Turda')
INSERT INTO TrainStations(StationName) VALUES ('Gara Debrecen')
INSERT INTO TrainStations(StationName) VALUES ('Gara Budapesta')
INSERT INTO TrainStations(StationName) VALUES ('Gara Brasov')

SELECT * FROM TrainStations

INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES (1, 2, '10:55:00', '11:10:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES (3, 1, '12:55:00', '13:20:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES (8, 3, '11:55:00', '12:10:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES (8, 4, '9:55:00', '10:05:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES (5, 5, '8:30:00', '8:45:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES (7, 6, '7:55:00', '8:05:00')

SELECT * FROM TrainStationRoutes
GO

CREATE OR ALTER PROCEDURE UPSERT 
	@ruta VARCHAR(100),
	@statie VARCHAR(100),
	@arrival TIME,
	@departure TIME
AS
BEGIN 
	DECLARE @rutaID INT
	DECLARE @stationID INT

	SELECT TOP 1 @rutaID = RouteID FROM TrainRoutes WHERE TrainRoutes.RouteName = @ruta
	SELECT TOP 1 @stationID = StationID FROM TrainStations WHERE TrainStations.StationName = @statie

	IF @rutaID IS NULL OR @stationID IS NULL
		THROW 50001, 'ID ruta sau ID statie invalid!', 1
	ELSE IF (EXISTS (SELECT * FROM TrainStationRoutes WHERE StationID = @stationID AND RouteID = @rutaID))
		UPDATE TrainStationRoutes SET Arrivals = @arrival, Departures = @departure WHERE StationID = @stationID AND RouteID = @rutaID
	ELSE 
		INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES (@stationID, @rutaID, @arrival, @departure)
END
GO

EXEC UPSERT 'Cluj - Bucuresti', 'Gara de Nord', '10:00:00', '11:00:00'
EXEC UPSERT 'Oradea - Budapesta', 'Gara Debrecen', '11:00:00', '14:00:00'
SELECT * FROM TrainStationRoutes

GO
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES(1, 1, '1:00:00', '2:00:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES(2, 1, '1:00:00', '2:00:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES(4, 1, '1:00:00', '2:00:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES(5, 1, '1:00:00', '2:00:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES(6, 1, '1:00:00', '2:00:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES(7, 1, '1:00:00', '2:00:00')
INSERT INTO TrainStationRoutes(StationID, RouteID, Arrivals, Departures) VALUES(8, 1, '1:00:00', '2:00:00')

SELECT * FROM TrainStationRoutes

GO

-- Task 3 (a)
CREATE OR ALTER VIEW viewStatiiRute AS
	SELECT r.RouteName FROM TrainRoutes r INNER JOIN TrainStationRoutes rs ON r.RouteID = rs.RouteID
	GROUP BY rs.RouteID, r.RouteName
	HAVING COUNT(*) = (SELECT COUNT(*) FROM TrainStations)
GO
SELECT * FROM viewStatiiRute

GO
-- Task 3 (b)
CREATE OR ALTER FUNCTION nrTrenuriStatie()
RETURNS TABLE 
AS
	RETURN SELECT DISTINCT s.StationName FROM TrainStations s INNER JOIN TrainStationRoutes rs ON rs.StationID = s.StationID
	INNER JOIN TrainStationRoutes rs2 ON rs2.StationID = rs.StationID AND rs2.RouteID <> rs.RouteID
	WHERE rs.Departures BETWEEN rs2.Departures AND rs2.Arrivals
GO

SELECT * FROM [dbo].nrTrenuriStatie()
EXEC UPSERT 'Galati - Cluj', 'Gara Centrala Cluj', '11:00:00', '07:00:00'
EXEC UPSERT 'Cluj - Bucuresti', 'Gara de Nord', '11:00:00', '10:55:00'
EXEC UPSERT 'Galati - Brasov', 'Gara Brasov', '12:10:00',' 11:55:00'
EXEC UPSERT 'Cluj - Brasov', 'Gara Brasov', '13:00:00',' 10:00:00'
SELECT * FROM TrainStationRoutes
