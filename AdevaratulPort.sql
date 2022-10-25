CREATE DATABASE Port
GO 

USE Port;

CREATE TABLE Managers(
	ManagerID INT NOT NULL PRIMARY KEY IDENTITY,
	ManagerSalary FLOAT CHECK (ManagerSalary >= 1500),
	ManagerBonus FLOAT CHECK (ManagerBonus <= 750),
	ManagerAge INT CHECK (ManagerAge >= 18 AND ManagerAge <= 65),
	ManagerExperience INT CHECK (ManagerExperience >= 3)
);

CREATE TABLE Employees(
	EmployeeID INT NOT NULL PRIMARY KEY IDENTITY,
	EmployeeSalary FLOAT CHECK (EmployeeSalary >= 1200 AND EmployeeSalary <= 1500),
	EmployeeBonus FLOAT CHECK (EmployeeBonus <= 450),
	EmployeeAge INT CHECK (EmployeeAge >= 18 AND EmployeeAge <= 65),
	ManagerID INT NOT NULL FOREIGN KEY REFERENCES Managers(ManagerID)
);

CREATE TABLE Machinery(
	MachineryID INT NOT NULL PRIMARY KEY IDENTITY,
	MachineryType VARCHAR(50) CHECK (MachineryType IN('Heavy', 'Medium', 'Small', 'Other')), 
	MachineryManufacturer VARCHAR(50) DEFAULT 'State Company'
);

CREATE TABLE MachineryEmployees(
	MachineryID INT NOT NULL FOREIGN KEY REFERENCES Machinery(MachineryID),
	EmployeeID INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
	CONSTRAINT pk_MachineryEmployees PRIMARY KEY(MachineryID, EmployeeID)
);

CREATE TABLE Warehouses(
	WarehouseID INT NOT NULL PRIMARY KEY IDENTITY,
	WarehouseCapacity FLOAT CHECK (WarehouseCapacity > 0),
	WarehouseGoods VARCHAR(50) DEFAULT 'Empty' CHECK (WarehouseGoods IN('Natural Resources', 'Synthetic Materials', 'Other', 'Empty')),
	WarehouseGoodsName VARCHAR(50) DEFAULT 'Empty'
);

CREATE TABLE WarehouseEmployees(
	EmployeeID INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
	WarehouseID INT NOT NULL FOREIGN KEY REFERENCES Warehouses(WarehouseID),
	CONSTRAINT pk_WarehouseEmployees PRIMARY KEY(WarehouseID, EmployeeID)
);

CREATE TABLE Goods(
	GoodsID INT NOT NULL PRIMARY KEY IDENTITY,
	GoodsType VARCHAR(50) CHECK (GoodsType IN('Industrial', 'Commercial', 'Special', 'Other')),
	GoodsName VARCHAR(50) DEFAULT 'Unspecified',
	GoodsWeight FLOAT CHECK (GoodsWeight >= 100 AND GoodsWeight <= 9999),
	GoodsPrice FLOAT NOT NULL
);

CREATE TABLE WarehouseGoods(
	WarehouseID INT NOT NULL FOREIGN KEY REFERENCES Warehouses(WarehouseID),
	GoodsID INT NOT NULL FOREIGN KEY REFERENCES Goods(GoodsID),
	CONSTRAINT pk_WarehouseGoods PRIMARY KEY(WarehouseID, GoodsID)
);

CREATE TABLE Resources(
	ResourceID INT NOT NULL PRIMARY KEY IDENTITY, 
	ResourceType VARCHAR(50) CHECK (ResourceType IN('Natural', 'Synthetic', 'Other')),
	ResourceName VARCHAR(50) DEFAULT 'Unspecified',
	ResourceWeight FLOAT CHECK (ResourceWeight >= 10 AND ResourceWeight <= 9999),
	ResourcePrice FLOAT NOT NULL 
);

CREATE TABLE WarehouseResources(
	WarehouseID INT NOT NULL FOREIGN KEY REFERENCES Warehouses(WarehouseID),
	ResourceID INT NOT NULL FOREIGN KEY REFERENCES Resources(ResourceID),
	CONSTRAINT pk_WarehouseResources PRIMARY KEY (WarehouseID, ResourceID),
	OccupiedSpace FLOAT NOT NULL 
);

CREATE TABLE Corporations(
	CorporationID INT NOT NULL PRIMARY KEY IDENTITY,
	CorporationCountry VARCHAR(50) DEFAULT 'Multinational',
	CorporationGoods VARCHAR(50) DEFAULT 'Undisclosed',
);

CREATE TABLE Ships(
	ShipID INT NOT NULL PRIMARY KEY IDENTITY, 
	ShipCountry VARCHAR(50) DEFAULT 'Unspecified',
	ShipTonnage FLOAT NOT NULL, 
	ShipType VARCHAR(50) DEFAULT 'Barge',
	CorporationID INT NOT NULL FOREIGN KEY REFERENCES Corporations(CorporationID)
);

CREATE TABLE Captains(
	CaptainID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
	CaptainSalary FLOAT CHECK (CaptainSalary >= 2000 AND CaptainSalary <= 4000),
	CaptainBonus FLOAT CHECK (CaptainBonus <= 1100),
	CaptainAge INT CHECK (CaptainAge >= 18 AND CaptainAge <= 65),
	CaptainExperience INT CHECK(CaptainExperience >= 5),
	CONSTRAINT pk_Captains PRIMARY KEY(CaptainID)
);

CREATE TABLE CorporationResources(
	CorporationID INT NOT NULL FOREIGN KEY REFERENCES Corporations(CorporationID),
	ResourceID INT NOT NULL FOREIGN KEY REFERENCES Resources(ResourceID),
	CONSTRAINT pk_CorporationResources PRIMARY KEY(CorporationID, ResourceID)
);

CREATE TABLE CorporationGoods(
	CorporationID INT NOT NULL FOREIGN KEY REFERENCES Corporations(CorporationID),
	GoodsID INT NOT NULL FOREIGN KEY REFERENCES Goods(GoodsID),
	CONSTRAINT pk_CorporationGoods PRIMARY KEY(CorporationID, GoodsID)
);

CREATE TABLE ShipResources(
	ResourceID INT NOT NULL FOREIGN KEY REFERENCES Resources(ResourceID),
	ShipID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
	CONSTRAINT pk_ShipResources PRIMARY KEY(ResourceID, ShipID),
	CargoWeight FLOAT NOT NULL
);

CREATE TABLE ShipGoods(
	ShipID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
	GoodsID INT NOT NULL FOREIGN KEY REFERENCES Goods(GoodsID),
	CONSTRAINT pk_ShipGoods PRIMARY KEY(GoodsID, ShipID),
	CargoGoodsWeight FLOAT NOT NULL
);

CREATE TABLE Sailors(
	SailorID INT NOT NULL PRIMARY KEY IDENTITY, 
	SailorSalary FLOAT CHECK (SailorSalary >= 1500 AND SailorSalary <= 2500),
	SailorBonus FLOAT CHECK (SailorBonus <= 700),
	SailorAge INT CHECK (SailorAge >= 18 AND SailorAge <= 65),
	SailorTimeAway INT,
	ShipID INT NOT NULL FOREIGN KEY REFERENCES Ships(ShipID),
);

ALTER TABLE Captains ADD CaptainName VARCHAR(64)
ALTER TABLE Sailors ADD SailorName VARCHAR(64)
ALTER TABLE Managers ADD ManagerName VARCHAR(64)
ALTER TABLE Employees ADD EmployeeName VARCHAR(64)
ALTER TABLE Ships ADD ShipName VARCHAR(64)
ALTER TABLE Corporations ADD CorpoName VARCHAR(64)

INSERT INTO Managers(ManagerSalary, ManagerBonus, ManagerAge, ManagerExperience, ManagerName) VALUES (1750, 500, 35, 10, 'Barney Calhoun');
INSERT INTO Managers(ManagerSalary, ManagerBonus, ManagerAge, ManagerExperience, ManagerName) VALUES (1950, 650, 43, 16, 'Henry Ross');
INSERT INTO Managers(ManagerSalary, ManagerBonus, ManagerAge, ManagerExperience, ManagerName) VALUES (1650, 150, 27, 3, 'Walter Hartwell White');
INSERT INTO Managers(ManagerSalary, ManagerBonus, ManagerAge, ManagerExperience, ManagerName) VALUES (2550, 750, 49, 23, 'Michael Ehrmantrout');
INSERT INTO Managers(ManagerSalary, ManagerBonus, ManagerAge, ManagerExperience, ManagerName) VALUES (1650, 250, 25, 3, 'Daniel Hayter');


INSERT INTO Employees(EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (1250, 300, 25, 3, 'Jesse Pinkman');
INSERT INTO Employees(EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (1350, 250, 37, 1, 'Gina Cross');
INSERT INTO Employees(EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (1450, 450, 49, 1, 'James Foreman');
INSERT INTO Employees(EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (1225, 150, 21, 2, 'Andrew Barnes');
INSERT INTO Employees(EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (1200, 175, 29, 2, 'Frank Breen');
INSERT INTO Employees(EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (1215, 235, 35, 4, 'Huell Babbitt');
INSERT INTO Employees(EmployeeSalary, EmployeeBonus, EmployeeAge, ManagerID, EmployeeName) VALUES (1345, 225, 18, 6, 'Robert Lewis');

INSERT INTO Machinery(MachineryType, MachineryManufacturer) VALUES ('Small', 'Hyundai');
INSERT INTO Machinery(MachineryType, MachineryManufacturer) VALUES ('Heavy', 'Samsung');
INSERT INTO Machinery(MachineryType, MachineryManufacturer) VALUES ('Heavy', 'Konecranes');
INSERT INTO Machinery(MachineryType, MachineryManufacturer) VALUES ('Medium', 'Seacom');
INSERT INTO Machinery(MachineryType, MachineryManufacturer) VALUES ('Other', 'Mantsines');

INSERT INTO MachineryEmployees(MachineryID, EmployeeID, MachineryUser) VALUES (1, 1, 'JesseYo');
INSERT INTO MachineryEmployees(MachineryID, EmployeeID, MachineryUser) VALUES (2, 5, 'FrankB');
INSERT INTO MachineryEmployees(MachineryID, EmployeeID, MachineryUser) VALUES (3, 6, 'HuellBabby');
INSERT INTO MachineryEmployees(MachineryID, EmployeeID, MachineryUser) VALUES (4, 2, 'Gina');
INSERT INTO MachineryEmployees(MachineryID, EmployeeID, MachineryUser) VALUES (5, 4, 'BarnacleMan');

SELECT * FROM Managers;
SELECT * FROM Employees;
SELECT * FROM Machinery;
SELECT * FROM MachineryEmployees;

SELECT ManagerName, EmployeeName, MachineryUser
FROM Managers, Employees, MachineryEmployees
WHERE ManagerExperience >= 10 
GROUP BY ManagerName, EmployeeName, MachineryUser
HAVING EmployeeSalary >= 1400 OR EmployeeAge BETWEEN 18 AND 45
ORDER BY ManagerName, EmployeeName, MachineryUser