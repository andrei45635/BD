CREATE DATABASE Port
GO 

USE Port;

--- CREARE BAZA DE DATE ---
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

CREATE TABLE Versions(
	VersionNo INT
);
INSERT INTO Versions(VersionNo) VALUES(0)
SELECT * FROM Versions
--- CREARE BAZA DE DATE ---

--- ALTERARI ---
ALTER TABLE Captains ADD CaptainName VARCHAR(64)
ALTER TABLE Sailors ADD SailorName VARCHAR(64)
ALTER TABLE Managers ADD ManagerName VARCHAR(64)
ALTER TABLE Employees ADD EmployeeName VARCHAR(64)
ALTER TABLE Ships ADD ShipName VARCHAR(64)
ALTER TABLE Corporations ADD CorpoName VARCHAR(64)
--- ALTERARI ---

--- INTEROGARI LAB ---
/*
	Grupeaza angajatii care au varsta intre 18 si 31 de ani care au salariu minim pe economie cu masinariile pe care le folosesc
*/
SELECT e.EmployeeName, e.EmployeeAge, mch.MachineryUser, mech.MachineryManufacturer
FROM Employees e INNER JOIN MachineryEmployees mch ON e.EmployeeID = mch.EmployeeID 
	             INNER JOIN Machinery mech ON mech.MachineryID = mch.MachineryID
WHERE EmployeeAge BETWEEN 18 AND 31 
GROUP BY e.EmployeeName, e.EmployeeAge, mch.MachineryUser, mech.MachineryManufacturer
HAVING AVG(EmployeeSalary) BETWEEN 1200 AND 1400
ORDER BY EmployeeName

/*
	Grupeaza angajatii care au un salariu mai mic de 1400 de euro cu managerii lor si cu depozitele unde lucreaza
*/
SELECT e.EmployeeName, m.ManagerName, e.EmployeeSalary, we.WarehouseID
FROM Employees e INNER JOIN WarehouseEmployees we ON e.EmployeeID = we.EmployeeID
				 INNER JOIN Managers m ON m.ManagerID = e.EmployeeID
GROUP BY e.EmployeeName, m.ManagerName,e.EmployeeSalary, we.WarehouseID
HAVING AVG(e.EmployeeSalary) <= 1400
ORDER BY m.ManagerName

/*
	Grupeaza capitanii cu corporatiile care detin navele pe care le conduc
*/
SELECT DISTINCT c.CaptainName, c.CaptainSalary + c.CaptainBonus * c.CaptainExperience * 0.125 AS monthlySalary, c.CaptainExperience, s.ShipName, cp.CorpoName, c.CaptainBonus
FROM Captains c INNER JOIN Ships s ON c.CaptainID = s.ShipID
				INNER JOIN Corporations cp ON s.CorporationID = cp.CorporationID
WHERE c.CaptainExperience >= 15
GROUP BY c.CaptainName, c.CaptainExperience, s.ShipName, cp.CorpoName, c.CaptainSalary, c.CaptainBonus
ORDER BY c.CaptainExperience ASC

/*
	Grupeaza bunurile din magazii in functie de pretul lor brut
*/
SELECT DISTINCT g.GoodsName, pretBrut = g.GoodsPrice * g.GoodsWeight
FROM WarehouseGoods wg INNER JOIN Goods g ON wg.GoodsID = g.GoodsID
					   INNER JOIN Warehouses w ON w.WarehouseID = wg.WarehouseID
GROUP BY g.GoodsName, g.GoodsPrice, g.GoodsWeight
HAVING AVG(w.WarehouseCapacity) BETWEEN 2000 AND 7000
ORDER BY g.GoodsName ASC

/*
	Grupeaza bunurile livrate de nave romanesti cu pretul brut intre 100k si 10M 
*/
SELECT s.ShipCountry, g.GoodsName, g.GoodsPrice, s.ShipName, s.ShipType
FROM Ships s INNER JOIN ShipGoods sg ON s.ShipID = sg.ShipID
			 INNER JOIN Goods g ON g.GoodsID = sg.GoodsID
WHERE s.ShipCountry = 'Romania'
GROUP BY s.ShipCountry, g.GoodsName, g.GoodsPrice, s.ShipName, s.ShipType
HAVING AVG(g.GoodsPrice * g.GoodsWeight) BETWEEN POWER(10,5) AND POWER(10,7)
ORDER BY g.GoodsPrice DESC

/*
	Grupeaza bunurile cu pretul aflat intre 100k si 10M in functie de companii
*/
SELECT s.ShipName, c.CorpoName, g.GoodsName, g.GoodsPrice, sg.CargoGoodsWeight
FROM Ships s INNER JOIN ShipGoods sg ON s.ShipID = sg.ShipID
			          INNER JOIN Corporations c ON c.CorporationID = s.ShipID
					  LEFT OUTER JOIN Goods g ON g.GoodsID = sg.GoodsID
WHERE s.ShipCountry = c.CorporationCountry AND g.GoodsPrice * sg.CargoGoodsWeight BETWEEN POWER(10, 5) AND POWER(10, 7)
GROUP BY s.ShipName, c.CorpoName, g.GoodsName, g.GoodsPrice, sg.CargoGoodsWeight
ORDER BY s.ShipName ASC

/*
	Grupeaza angajatii aflati in subordinea unui manager cu bunurile depozitului unde lucreaza
*/
SELECT DISTINCT e.EmployeeName, m.ManagerName
FROM Employees e INNER JOIN Managers m ON e.ManagerID = m.ManagerID
							   INNER JOIN WarehouseEmployees we ON we.EmployeeID = e.EmployeeID
							   INNER JOIN Warehouses w ON we.WarehouseID = w.WarehouseID
WHERE e.EmployeeAge BETWEEN 18 AND 28
GROUP BY e.EmployeeName, m.ManagerName
HAVING AVG(e.EmployeeSalary) BETWEEN 1200 AND 1900
ORDER BY e.EmployeeName ASC

/*
	Grupeaza marinarii de pe nave romanesti cu capitanii navelor
*/
SELECT sl.SailorName, s.ShipName, sl.SailorTimeAway 
FROM Sailors sl INNER JOIN Ships s ON s.ShipID = sl.ShipID
				INNER JOIN Captains c ON c.CaptainID = s.ShipID
WHERE s.ShipCountry = 'Romania'
GROUP BY sl.SailorName, s.ShipName, sl.SailorTimeAway 
ORDER BY sl.SailorTimeAway

/*
	Grupeaza corporatiile din Romania sau Austria cu bunurile si resursele pe care le livreaza
*/
SELECT c.CorpoName, g.GoodsName, r.ResourceName
FROM CorporationGoods cg INNER JOIN Corporations c ON c.CorporationID = cg.CorporationID
				         INNER JOIN Goods g ON cg.GoodsID = g.GoodsID
						 INNER JOIN CorporationResources cr ON cr.CorporationID = c.CorporationID
						 INNER JOIN Resources r ON r.ResourceID = cr.ResourceID
WHERE c.CorporationCountry = 'Romania' OR c.CorporationCountry = 'Austria'

/*
	Grupeaza resursele din depozite cu corporatiile de la care provin filtrate in functie de tara (RO sau RU)
*/
SELECT DISTINCT r.ResourceName, c.CorpoName
FROM Resources r INNER JOIN WarehouseResources wr ON r.ResourceID = wr.ResourceID
				 INNER JOIN Warehouses w ON w.WarehouseID = wr.WarehouseID
				 INNER JOIN CorporationResources cr ON cr.ResourceID = r.ResourceID
				 INNER JOIN Corporations c ON c.CorporationID = cr.CorporationID
WHERE c.CorporationCountry = 'Romania' OR c.CorporationCountry = 'Russia'
--- INTEROGARI LAB ---

--- INSERARI DE DATE --- 
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

INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (2, 2)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (1, 6)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (4, 4)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (6, 7)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (3, 2)
INSERT INTO WarehouseGoods(WarehouseID, GoodsID) VALUES (5, 4)
ALTER TABLE WarehouseGoods DROP COLUMN GoodsTonnage

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

INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1750, 500, 28, 12, 1, 'Andrei Munteanu')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (2500, 700, 48, 12, 1, 'Mihaly Vitez')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1550, 250, 33, 9, 5, 'Umberto Fesa')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1650, 340, 25, 4, 6, 'Nicholas Soldab')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1820, 420, 38, 6, 7, 'Rares Bogdan')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1945, 569, 29, 6, 7, 'Mihai Gadea')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1725, 159, 37, 12, 4, 'Mircea Badea')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1984, 360, 51, 12, 3, 'George Orwell')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1555, 150, 24, 3, 2, 'Andrei Munteanu')
INSERT INTO Sailors(SailorSalary, SailorBonus, SailorAge, SailorTimeAway, ShipID, SailorName) VALUES (1500, 100, 64, 12, 1, 'Traian Basescu')

INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (1, 1, 4995)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (3, 7, 1971)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (3, 2, 2482)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (1, 4, 4995)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (2, 5, 3492)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (2, 3, 1009)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (1, 6, 4995)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (4, 7, 2482)
INSERT INTO ShipResources(ResourceID, ShipID, CargoWeight) VALUES (3, 3, 549)

INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (1, 1)
INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (1, 5)
INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (2, 4)
INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (3, 6)
INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (4, 2)
INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (5, 3)
INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (7, 6)
INSERT INTO WarehouseEmployees(EmployeeID, WarehouseID) VALUES (7, 3)

INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (1, 1)
INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (6, 1)
INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (6, 3)
INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (6, 2)
INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (7, 4)
INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (7, 5)
INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (2, 4)
INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (5, 3)

INSERT INTO CorporationGoods(CorporationID, GoodsID) VALUES (7, 7)
INSERT INTO CorporationGoods(CorporationID, GoodsID) VALUES (3, 1)
INSERT INTO CorporationGoods(CorporationID, GoodsID) VALUES (3, 8)
INSERT INTO CorporationGoods(CorporationID, GoodsID) VALUES (4, 6)
INSERT INTO CorporationGoods(CorporationID, GoodsID) VALUES (5, 3)
INSERT INTO CorporationGoods(CorporationID, GoodsID) VALUES (2, 2)

INSERT INTO WarehouseResources(WarehouseID, ResourceID, OccupiedSpace) VALUES (1, 1, 500)
INSERT INTO WarehouseResources(WarehouseID, ResourceID, OccupiedSpace) VALUES (3, 3, 1205)
INSERT INTO WarehouseResources(WarehouseID, ResourceID, OccupiedSpace) VALUES (2, 2, 954)
INSERT INTO WarehouseResources(WarehouseID, ResourceID, OccupiedSpace) VALUES (4, 4, 2412)
INSERT INTO WarehouseResources(WarehouseID, ResourceID, OccupiedSpace) VALUES (4, 5, 4521)
--- INSERARI DE DATE --- 

--- VERIFICARI --- 
SELECT * FROM Captains;
SELECT * FROM Sailors;
SELECT * FROM Corporations;
SELECT * FROM CorporationGoods;
SELECT * FROM CorporationResources;
SELECT * FROM Ships;
SELECT * FROM ShipResources;
SELECT * FROM Goods;
SELECT * FROM Managers;
SELECT * FROM Employees;
SELECT * FROM Machinery;
SELECT * FROM MachineryEmployees;
SELECT * FROM ShipGoods;
SELECT * FROM Warehouses;
SELECT * FROM WarehouseGoods;
SELECT * FROM WarehouseEmployees;
SELECT * FROM Resources;
SELECT * FROM WarehouseResources;
--- VERIFICARI ---

DELETE FROM Goods
DBCC CHECKIDENT ('Goods', RESEED, 0)
GO
