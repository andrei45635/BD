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
	CaptainID INT NOT NULL FOREIGN KEY REFERENCES Captains(CaptainID)
);

ALTER TABLE Captains ADD CaptainName VARCHAR(64)
ALTER TABLE Sailors ADD SailorName VARCHAR(64)
ALTER TABLE Managers ADD ManagerName VARCHAR(64)
ALTER TABLE Employees ADD EmployeeName VARCHAR(64)
ALTER TABLE Ships ADD ShipName VARCHAR(64)
ALTER TABLE Corporations ADD CorpoName VARCHAR(64)
ALTER TABLE MachineryEmployees ADD MachineryUser VARCHAR(64)

--- INTEROGARI LAB ---
/*
	Grupeaza angajatii care au varsta intre 18 si 31 de ani cu masinariile pe care le folosesc
*/
SELECT e.EmployeeName, mch.MachineryUser, mech.MachineryManufacturer
FROM Employees e INNER JOIN MachineryEmployees mch ON e.EmployeeID = mch.EmployeeID 
	             INNER JOIN Machinery mech ON mech.MachineryID = mch.MachineryID
WHERE EmployeeAge BETWEEN 18 AND 31 AND EmployeeSalary + EmployeeBonus <= 2000
GROUP BY e.EmployeeName, mech.MachineryManufacturer, mch.MachineryUser
HAVING SUM(EmployeeSalary) BETWEEN 1200 AND 9999
ORDER BY EmployeeName

/*
	Grupeaza angajatii care au un salariu mai mic de 1400 de euro cu managerii cu experienta mai mica de 15 ani
*/
SELECT e.EmployeeName, m.ManagerName, m.ManagerExperience, e.EmployeeSalary
FROM Employees e INNER JOIN Managers m ON e.ManagerID = m.ManagerID
GROUP BY e.EmployeeName, m.ManagerName, m.ManagerExperience, e.EmployeeSalary
HAVING e.EmployeeSalary <= 1400 AND m.ManagerExperience < 15
ORDER BY m.ManagerName

/*
	Grupeaza capitanii cu corporatiile care detin navele pe care le conduc
*/
SELECT DISTINCT c.CaptainExperience, c.CaptainName, s.ShipName, cp.CorpoName, c.CaptainSalary, c.CaptainBonus
FROM Captains c INNER JOIN Ships s ON c.CaptainID = s.ShipID
				INNER JOIN Corporations cp ON s.CorporationID = cp.CorporationID
WHERE c.CaptainExperience >= 15
GROUP BY c.CaptainName, c.CaptainExperience, s.ShipName, cp.CorpoName, c.CaptainSalary, c.CaptainBonus
HAVING c.CaptainBonus <= c.CaptainSalary/c.CaptainExperience * 125
ORDER BY c.CaptainExperience ASC

/*
	Grupeaza bunurile din magazii in functie de pretul lor brut
*/
SELECT DISTINCT g.GoodsName, w.WarehouseGoodsName, g.GoodsPrice, w.WarehouseCapacity, g.GoodsWeight
FROM Goods g INNER JOIN WarehouseGoods wg ON wg.GoodsID = g.GoodsID
			 INNER JOIN Warehouses w ON w.WarehouseID = wg.WarehouseID
GROUP BY g.GoodsName, w.WarehouseGoodsName, g.GoodsPrice, w.WarehouseCapacity, g.GoodsWeight
HAVING g.GoodsPrice * g.GoodsWeight <= 599999
ORDER BY g.GoodsPrice ASC

/*
	Grupeaza bunurile livrate de nave romanesti
*/
SELECT s.ShipCountry, g.GoodsName, g.GoodsPrice, s.ShipName, s.ShipType
FROM Ships s INNER JOIN ShipGoods sg ON s.ShipID = sg.ShipID
			 INNER JOIN Goods g ON g.GoodsID = sg.GoodsID
WHERE s.ShipCountry = 'Romania'
GROUP BY s.ShipCountry, g.GoodsName, g.GoodsPrice, s.ShipName, s.ShipType
HAVING AVG(g.GoodsPrice * g.GoodsWeight) <= 999999
ORDER BY g.GoodsPrice DESC

--- INTEROGARI LAB ---
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Special', 'Half-Life', 4200, 59.99)
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Industrial', 'Steel Rods', 9000, 119.99)
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Industrial', 'Furnaces', 9999, 599.99)
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Commercial', 'Television', 8999, 2999.99)
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Commercial', 'Desktops', 3245, 4999.99)
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Industrial', 'Fertilizer', 4999, 99.99)
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Other', 'Medical Supplies', 8499, 49.99)
INSERT INTO Goods(GoodsType, GoodsName, GoodsWeight, GoodsPrice) VALUES ('Special', 'Vidya', 2999, 39.99)

INSERT INTO Warehouses(WarehouseCapacity, WarehouseGoods, WarehouseGoodsName) VALUES (4299, 'Natural Resources', 'Gas')
INSERT INTO Warehouses(WarehouseCapacity, WarehouseGoods, WarehouseGoodsName) VALUES (3999, 'Synthetic Materials', 'Furnaces')
INSERT INTO Warehouses(WarehouseCapacity, WarehouseGoods, WarehouseGoodsName) VALUES (2499, 'Natural Resources', 'Petrol')
INSERT INTO Warehouses(WarehouseCapacity, WarehouseGoods, WarehouseGoodsName) VALUES (2999, 'Other', 'Vidya')
INSERT INTO Warehouses(WarehouseCapacity, WarehouseGoods, WarehouseGoodsName) VALUES (8499, 'Synthetic Materials', 'Medical Supplies')
INSERT INTO Warehouses(WarehouseCapacity, WarehouseGoods, WarehouseGoodsName) VALUES (5299, 'Other', 'Half-Life')

INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES ('Romania', 'Natural Resources', 'Volve')
INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES ('UK', 'Construction Materials', 'Animus')
INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES ('United States of America', 'Technology', 'Valve')
INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES ('Mexico', 'Vegetables (Beans)', 'BeanerInc')
INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES ('Austria', 'Petrol', 'OMV')
INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES ('Russia', 'Natural Resources', 'Gazprom')
INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES ('Romania', 'Gravel', 'Dunarom')

INSERT INTO Ships(ShipCountry, ShipTonnage, ShipType, CorporationID, ShipName) VALUES ('Romania', 89999, 'Cargo Freighter', 1, 'Invictus')
INSERT INTO Ships(ShipCountry, ShipTonnage, ShipType, CorporationID, ShipName) VALUES ('Venezuela', 24000, 'Barge', 2, 'SS Chavez')
INSERT INTO Ships(ShipCountry, ShipTonnage, ShipType, CorporationID, ShipName) VALUES ('Nigeria', 45699, 'Medium Cargo Freighter', 4, 'Magumba')
INSERT INTO Ships(ShipCountry, ShipTonnage, ShipType, CorporationID, ShipName) VALUES ('Austria', 99453, 'Cargo Freighter', 5, 'K.u.K. Franz Joseph I')
INSERT INTO Ships(ShipCountry, ShipTonnage, ShipType, CorporationID, ShipName) VALUES ('UK', 44354, 'Dry Bulk Carrier', 3, 'HMS Seven Seas')
INSERT INTO Ships(ShipCountry, ShipTonnage, ShipType, CorporationID, ShipName) VALUES ('China', 129822, 'Multi Purpose Vessel', 6, 'Dragon of Xinjiang')
INSERT INTO Ships(ShipCountry, ShipTonnage, ShipType, CorporationID, ShipName) VALUES ('Romania', 214124, 'Ultra Large Carrier Freighter', 1, 'SS Marian')

INSERT INTO Captains(CaptainID, CaptainSalary, CaptainBonus, CaptainAge, CaptainExperience, CaptainName) VALUES (5, 3000, 1000, 55, 25, 'Harold Shepard')
INSERT INTO Captains(CaptainID, CaptainSalary, CaptainBonus, CaptainAge, CaptainExperience, CaptainName) VALUES (1, 2500, 300, 31, 6, 'Andrew Jackson')
INSERT INTO Captains(CaptainID, CaptainSalary, CaptainBonus, CaptainAge, CaptainExperience, CaptainName) VALUES (4, 4000, 1100, 60, 32, 'Eli Vance')
INSERT INTO Captains(CaptainID, CaptainSalary, CaptainBonus, CaptainAge, CaptainExperience, CaptainName) VALUES (7, 4000, 1100, 51, 30, 'Marian Iacob')
INSERT INTO Captains(CaptainID, CaptainSalary, CaptainBonus, CaptainAge, CaptainExperience, CaptainName) VALUES (3, 4000, 1100, 55, 28, 'Isaac Kleiner')
INSERT INTO Captains(CaptainID, CaptainSalary, CaptainBonus, CaptainAge, CaptainExperience, CaptainName) VALUES (6, 3800, 900, 47, 20, 'Gordon Freeman')
INSERT INTO Captains(CaptainID, CaptainSalary, CaptainBonus, CaptainAge, CaptainExperience, CaptainName) VALUES (2, 4000, 1100, 52, 32, 'G-Man')

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

INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (2, 2)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (1, 6)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (4, 4)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (6, 7)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (3, 2)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (5, 4)

INSERT INTO ShipGoods(ShipID, GoodsID, CargoGoodsWeight) VALUES (7, 3, 8999)
INSERT INTO ShipGoods(ShipID, GoodsID, CargoGoodsWeight) VALUES (5, 2, 2999)
INSERT INTO ShipGoods(ShipID, GoodsID, CargoGoodsWeight) VALUES (4, 1, 1245)
INSERT INTO ShipGoods(ShipID, GoodsID, CargoGoodsWeight) VALUES (2, 5, 4222)
INSERT INTO ShipGoods(ShipID, GoodsID, CargoGoodsWeight) VALUES (3, 7, 3212)
INSERT INTO ShipGoods(ShipID, GoodsID, CargoGoodsWeight) VALUES (1, 8, 2512)
INSERT INTO ShipGoods(ShipID, GoodsID, CargoGoodsWeight) VALUES (6, 4, 1782)

INSERT INTO Resources(ResourceType, ResourceName, ResourcePrice, ResourceWeight) VALUES ('Natural', 'Gas', 321.99, 8999)
INSERT INTO Resources(ResourceType, ResourceName, ResourcePrice, ResourceWeight) VALUES ('Synthetic', 'Petrol', 101.99, 4956)
INSERT INTO Resources(ResourceType, ResourceName, ResourcePrice, ResourceWeight) VALUES ('Natural', 'Petrol', 121.99, 4999)
INSERT INTO Resources(ResourceType, ResourceName, ResourcePrice, ResourceWeight) VALUES ('Other', 'Gravel', 55.99, 9999)
INSERT INTO Resources(ResourceType, ResourceName, ResourcePrice, ResourceWeight) VALUES ('Other', 'Tungsten', 42.99, 1299)

SELECT * FROM Captains;
SELECT * FROM Corporations;
SELECT * FROM Ships;
SELECT * FROM Goods;
SELECT * FROM Managers;
SELECT * FROM Employees;
SELECT * FROM Machinery;
SELECT * FROM MachineryEmployees;
SELECT * FROM ShipGoods;
SELECT * FROM Warehouses;
SELECT * FROM WarehouseGoods;
SELECT * FROM Resources;

DELETE FROM Goods
DBCC CHECKIDENT ('Goods', RESEED, 0)
GO
