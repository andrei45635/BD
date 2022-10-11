CREATE DATABASE PortGalati
GO
USE PortGalati;

CREATE TABLE Managers(
	idMg INT NOT NULL PRIMARY KEY IDENTITY,
	MgName VARCHAR(50) DEFAULT 'AnonMg',
	MgAge INT CHECK (MgAge >= 18 AND MgAge <= 65),
	MgSalary FLOAT CHECK (MgSalary >= 1200),
	MgBonus FLOAT CHECK (MgBonus <= 600)
);

CREATE TABLE Warehouses(
	idW INT NOT NULL PRIMARY KEY IDENTITY, 
	WareName VARCHAR(50) DEFAULT 'General Warehouse',
	WareGood VARCHAR(50) DEFAULT 'General Goods',
);


CREATE TABLE Employees(
	idEmp INT NOT NULL PRIMARY KEY IDENTITY,
	EmpName VARCHAR(50) DEFAULT 'AnonEmp',
	EmpAge INT CHECK (EmpAge >= 18 AND EmpAge <= 65),
	EmpSalary FLOAT CHECK (EmpSalary >= 900),
	idMg INT NOT NULL FOREIGN KEY REFERENCES Managers(idMg),
	idW INT NOT NULL FOREIGN KEY REFERENCES Warehouses(idW)
);

CREATE TABLE NavalPorts(
	idP INT NOT NULL PRIMARY KEY IDENTITY, 
	PortType VARCHAR(25) DEFAULT 'Medium',
	OriginCountry VARCHAR(60),
	ShipCount INT NOT NULL,
	Departures DATETIME,
	Arrivals DATETIME
);

CREATE TABLE WarePorts(
	idP INT NOT NULL FOREIGN KEY REFERENCES NavalPorts(idP),
	idW INT NOT NULL FOREIGN KEY REFERENCES Warehouses(idW),
	CONSTRAINT pk_WarePorts PRIMARY KEY(idP, idW)
);

CREATE TABLE Corporations(
	idC INT NOT NULL PRIMARY KEY IDENTITY,
	CorpoName VARCHAR(50) DEFAULT 'AnonComp',
	CorpoGoods VARCHAR(50) DEFAULT 'Unspecified', 
	CorpoShip VARCHAR(50), 
);

CREATE TABLE Goods(
	idG INT NOT NULL PRIMARY KEY IDENTITY, 
	GoodsType VARCHAR(50) DEFAULT 'Unspecified', 
	GoodsWeight FLOAT CHECK (GoodsWeight >= 50 AND GoodsWeight <= 999),
	GoodsPrice FLOAT NOT NULL,
	idC INT NOT NULL FOREIGN KEY REFERENCES Corporations(idC)
);

CREATE TABLE Ships(
	idS INT NOT NULL PRIMARY KEY IDENTITY, 
	ShipName VARCHAR(50) DEFAULT 'SS Anon',
	ShipType VARCHAR(50) DEFAULT 'Barge',
	ShipTonnage FLOAT CHECK (ShipTonnage <= 999)
);

CREATE TABLE Sailors(
	idSr INT NOT NULL PRIMARY KEY IDENTITY, 
	SailorName VARCHAR(50) DEFAULT 'Anon Sailor',
	SailorAge INT CHECK (SailorAge >= 18 AND SailorAge <= 55),
	SailorSalary FLOAT CHECK (SailorSalary >= 1000),
	idS INT NOT NULL FOREIGN KEY REFERENCES Ships(idS)
);

CREATE TABLE CorposInPorts(
	idC INT NOT NULL FOREIGN KEY REFERENCES Corporations(idC),
	idP INT NOT NULL FOREIGN KEY REFERENCES NavalPorts(idP),
	CONSTRAINT pk_CorposInPorts PRIMARY KEY(idC, idP)
);

CREATE TABLE CorpoShips(
	idC INT NOT NULL FOREIGN KEY REFERENCES Corporations(idC),
	idS INT NOT NULL FOREIGN KEY REFERENCES Ships(idS),
	CONSTRAINT pk_CorpoShips PRIMARY KEY(idC, idS)
);
