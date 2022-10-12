CREATE DATABASE GalatiPort
GO

USE GalatiPort;

CREATE TABLE Warehouses(
	WarehouseID INT NOT NULL PRIMARY KEY IDENTITY, 
	WarehouseGoods VARCHAR(50),
	WarehouseLocation VARCHAR(10) CHECK (WarehouseLocation IN ('North' , 'South', 'West', 'East')),
	WarehouseEmployees INT NOT NULL,
	WarehouseManager VARCHAR(50),
);

CREATE TABLE Managers(
	ManagerID INT NOT NULL FOREIGN KEY REFERENCES Warehouses(WarehouseID),
	ManagerName VARCHAR(60) DEFAULT 'AnonManager',
	ManagerAge INT CHECK (ManagerAge >= 18 AND ManagerAge <= 65),
	ManagerSalary FLOAT CHECK (ManagerSalary >= 1500),
	ManagerSalaryBonus FLOAT CHECK (ManagerSalaryBonus <= 700),
	CONSTRAINT pk_WarehouseManager PRIMARY KEY(ManagerID)
);

CREATE TABLE Employees(
	EmpID INT NOT NULL PRIMARY KEY IDENTITY, 
	EmpName VARCHAR(60) DEFAULT 'AnonEmployee',
	EmpAge INT CHECK (EmpAge >= 18 AND EmpAge <= 65),
	EmpSalary FLOAT CHECK (EmpSalary >= 1200 AND EmpSalary <= 1500),
	ManagerID INT NOT NULL FOREIGN KEY REFERENCES Managers(ManagerID),
	WarehouseID INT NOT NULL FOREIGN KEY REFERENCES Warehouses(WarehouseID)
);

CREATE TABLE PortGalati(
	PortID INT NOT NULL PRIMARY KEY, 
	Country VARCHAR(50) DEFAULT 'Unspecified', 
	Departures DATETIME,
	Arrivals DATETIME,
	ShipCount INT 
);

CREATE TABLE Corporations(
	CorporationID INT NOT NULL PRIMARY KEY IDENTITY, 
	CorporationName VARCHAR(50) DEFAULT 'Unspecified',
	CorporationCountry VARCHAR(50) DEFAULT 'Global', 
	PortID INT NOT NULL FOREIGN KEY REFERENCES PortGalati(PortID)
);

CREATE TABLE Ships(
	ShipID INT NOT NULL PRIMARY KEY IDENTITY,
	ShipName VARCHAR(50) DEFAULT 'SS Anon',
	ShipCountry VARCHAR(50) DEFAULT 'Unspecified',
	ShipType VARCHAR(50) CHECK (ShipType IN('Small Cargo', 'Medium Barge', 'Large Freighter')),
	ShipTonnage FLOAT CHECK (ShipTonnage <= 9999),
	PortID INT NOT NULL FOREIGN KEY REFERENCES PortGalati(PortID)
);

CREATE TABLE CorporationsShips(
	ShipID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
	CorporationID INT NOT NULL FOREIGN KEY REFERENCES Corporations(CorporationID),
	CONSTRAINT pk_CorpoShips PRIMARY KEY(ShipID, CorporationID)
);

CREATE TABLE Goods(
	GoodsID INT NOT NULL PRIMARY KEY IDENTITY,
	GoodsType VARCHAR(50) CHECK (GoodsType IN ('Food', 'Natural Resources', 'Synthetics', 'Other')),
	GoodsWeight FLOAT NOT NULL CHECK (GoodsWeight <= 9999),
);

CREATE TABLE GoodsCorporations(
	GoodsID INT NOT NULL FOREIGN KEY REFERENCES Goods(GoodsID),
	CorporationID INT NOT NULL FOREIGN KEY REFERENCES Corporations(CorporationID),
	CONSTRAINT pk_CorpoGoods PRIMARY KEY(GoodsID, CorporationID)
);

CREATE TABLE GoodsShips(
	GoodsID INT NOT NULL FOREIGN KEY REFERENCES Goods(GoodsID),
	ShipID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
	CONSTRAINT pk_ShipsGoods PRIMARY KEY(GoodsID, ShipID)
);

CREATE TABLE WarehousesGoods(
	GoodsID INT NOT NULL FOREIGN KEY REFERENCES Goods(GoodsID),
	WarehouseID INT NOT NULL FOREIGN KEY REFERENCES Warehouses(WarehouseID),
	CONSTRAINT pk_WarehousesGoods PRIMARY KEY(GoodsID, WarehouseID)
);

CREATE TABLE Captains(
	CaptainID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
	CONSTRAINT pk_ShipCaptain PRIMARY KEY(CaptainID)
);

CREATE TABLE Sailors(
	SailorID INT NOT NULL PRIMARY KEY IDENTITY,
	SailorName VARCHAR(50) DEFAULT 'AnonSailor',
	SailorAge INT CHECK (SailorAge >= 18 AND SailorAge <= 65),
	SailorSalary FLOAT CHECK (SailorSalary >= 1000 AND SailorSalary <= 1500),
	ShipID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
	CaptainID INT NOT NULL FOREIGN KEY REFERENCES Captains(CaptainID)
);

ALTER TABLE Captains
ADD CaptainAge INT NOT NULL CHECK (CaptainAge >= 18 AND CaptainAge <= 65), CaptainName VARCHAR(50) DEFAULT 'AnonSkip', CaptainSalary FLOAT CHECK (CaptainSalary >= 2000)

CREATE TABLE Machinery(
	MachineryID INT NOT NULL PRIMARY KEY IDENTITY, 
	MachineryType VARCHAR(50) CHECK (MachineryType IN('Ship to Shore crane', 'Reach stacker', 'Material Handling Equipment', 'Other')),
	PortID INT NOT NULL FOREIGN KEY REFERENCES PortGalati(PortID)
);