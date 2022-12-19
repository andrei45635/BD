USE [Port]
GO

----------------------------------------------------- VERIFICARI -----------------------------------------------------

-- verificare Corporations
-- returneaza mesaj de eroare corespunzator

CREATE OR ALTER PROCEDURE [dbo].verificareCorporations 
	@flag BIT OUTPUT,
	@msg VARCHAR(250) OUTPUT,
	@country VARCHAR(50),
	@goods VARCHAR(50), 
	@nume VARCHAR(50)
AS
BEGIN
	DECLARE @sumaErr INT
	SET @flag = 0
	SET @msg = ''
	SET @sumaErr = 0
	
	IF dbo.validareCampuriCorporatie(@country) = 1
	BEGIN
		SET @msg = @msg + ' tara invalida! '
	END
	
	IF dbo.validareCampuriCorporatie(@Goods) = 1
	BEGIN
		SET @msg = @msg + ' bunuri invalide! '
	END
	
	IF dbo.validareCampuriCorporatie(@nume) = 1
	BEGIN
		SET @msg = @msg + ' nume corporatie invalid! '
	END
	
	SET @sumaErr = @sumaErr + dbo.validareCampuriCorporatie(@country) + dbo.validareCampuriCorporatie(@Goods) + dbo.validareCampuriCorporatie(@nume)	
	IF @sumaErr > 0
	BEGIN
		SET @flag = 1
	END
END
GO

-- verificare Resources
-- returneaza mesaj de eroare corespunzator

CREATE OR ALTER PROCEDURE [dbo].verificareResurse
	@flag BIT OUTPUT,
	@msg VARCHAR(250) OUTPUT,
	@type VARCHAR(50),
	@name VARCHAR(50),
	@weight FLOAT,
	@price FLOAT
AS
BEGIN
	DECLARE @sumaErr INT
	SET @flag = 0
	SET @msg = ''
	SET @sumaErr = 0
	
	IF dbo.validareTipResursa(@type) = 1
	BEGIN
		SET @msg = @msg + ' tip resursa invalid!'
	END
	
	IF dbo.validareNumeResursa(@name) = 1
	BEGIN
		SET @msg = @msg + ' nume resursa invalid! '
	END

	IF dbo.validareGreutateResursa(@weight) = 1
	BEGIN
		SET @msg = @msg + ' greutate resursa invalida! '
	END

	IF dbo.validarePretResursa(@price) = 1
	BEGIN 
		SET @msg = @msg + ' pret resursa invalid! '
	END

	SET @sumaErr += @sumaErr + dbo.validareTipResursa(@type) + dbo.validareNumeResursa(@name) + dbo.validareGreutateResursa(@weight) + dbo.validarePretResursa(@price)
	IF @sumaErr > 0
	BEGIN
		SET @flag = 1
	END
END
GO

-- verificare CorporationResources
-- returneaza mesaj de eroare corespunzator

CREATE OR ALTER PROCEDURE [dbo].verificareCorporationResources
	@flag BIT OUTPUT,
	@msg VARCHAR(250) OUTPUT,
	@ResourceID INT,
	@CorpoID INT
AS
BEGIN
	DECLARE @sumaErr INT
	SET @flag = 0
	SET @msg = ''
	SET @sumaErr = 0

	IF dbo.validareCorpoID(@CorpoID) = 1
	BEGIN
		SET @msg = @msg + ' resource id invalid! '
	END

	IF dbo.validareResourceID(@ResourceID) = 1
	BEGIN
		SET @msg = @msg + ' corpo id invalid! '
	END

	SET @sumaErr = @sumaErr + dbo.validareCorpoID(@CorpoID) + dbo.validareResourceID(@ResourceID)
	IF @sumaErr > 0
	BEGIN
		SET @flag = 1
	END
END
GO


----------------------------------------------------- CRUD -----------------------------------------------------


-- CRUD for the Corporations table
-- exec CorpoCRUD 'CorpoCountry', 'CorpoGoods', 'CorpoName', noOfRows
-- CorpoID should be IDENTITY

CREATE OR ALTER PROCEDURE [dbo].CorpoCRUD
	@country VARCHAR(50),
	@goods VARCHAR(50),
	@name VARCHAR(50),
	@noOfRows INT
AS
BEGIN
	DECLARE @currentNoOfRows INT
	DECLARE @msg VARCHAR(250)
	DECLARE @flag BIT

	-- verificare date
	EXEC dbo.verificareCorporations @flag OUTPUT, @msg OUTPUT, @country, @goods, @name 

	IF @flag = 1
		PRINT 'Erori: ' + @msg
	ELSE
		BEGIN
			PRINT 'OK'
			--- INSERT ---
			SET @currentNoOfRows = 0
			WHILE @currentNoOfRows < @noOfRows
			BEGIN
				INSERT INTO Corporations(CorporationCountry, CorporationGoods, CorpoName) VALUES (@country, @goods, @name)
				SET @currentNoOfRows = @currentNoOfRows + 1
			END

			--- SELECT ---
			SELECT * FROM Corporations

			--- UPDATE --- 
			UPDATE Corporations SET CorporationCountry = 'Romania' WHERE CorporationGoods = 'Petrol'

			--- DELETE ---
			DELETE FROM Corporations WHERE CorporationGoods = 'Austria'

			PRINT 'CRUD operations for table Corporations' 
		END
END
GO

-- CRUD for the Resources table
-- exec ResourceCRUD ResourceType, ResourceName, ResourceWeight, ResourcePrice, noOfRows
-- ResourceID should be IDENTITY

CREATE OR ALTER PROCEDURE [dbo].ResourceCRUD
	@type VARCHAR(50),
	@name VARCHAR(50),
	@weight FLOAT,
	@price FLOAT,
	@noOfRows INT
AS
BEGIN
	DECLARE @currentNoOfRows INT
	DECLARE @msg VARCHAR(250)
	DECLARE @flag BIT

	-- verificare date
	EXEC dbo.verificareResurse @flag OUTPUT, @msg OUTPUT, @type, @name, @weight, @price

	IF @flag = 1
		PRINT 'Erori: ' + @msg
	ELSE
		BEGIN
			PRINT 'OK'
			--- INSERT ---
			SET @currentNoOfRows = 0
			WHILE @currentNoOfRows < @noOfRows
			BEGIN
				INSERT INTO Resources(ResourceType, ResourceName, ResourceWeight, ResourcePrice) VALUES (@type, @name, @weight, @price)
				SET @currentNoOfRows = @currentNoOfRows + 1
			END

			--- SELECT ---
			SELECT * FROM Resources

			--- UPDATE --- 
			UPDATE Resources SET ResourcePrice = @price WHERE ResourceWeight BETWEEN 7000 AND 8000

			--- DELETE ---
			DELETE FROM Resources WHERE ResourcePrice = @price

			PRINT 'CRUD operations for table Resources' 
		END
END
GO

-- CRUD for the CorporationResources
-- exec CorpoResCRUD CorpoID, ResourceID

CREATE OR ALTER PROCEDURE [dbo].CorpoResCRUD 
	@CorpoID INT,
	@ResourceID INT
AS
BEGIN
	DECLARE @msg VARCHAR(250)
	DECLARE @flag BIT

	-- verificare date
	EXEC dbo.verificareCorporationResources @flag OUTPUT, @msg OUTPUT, @ResourceID, @CorpoID 

	IF @flag = 1
		PRINT 'Erori: ' + @msg
	ELSE
		BEGIN
			PRINT 'OK'
			--- INSERT ---
			INSERT INTO CorporationResources(CorporationID, ResourceID) VALUES (@CorpoID, @ResourceID)

			--- SELECT ---
			SELECT * FROM CorporationResources

			--- UPDATE --- 
			UPDATE CorporationResources SET CorporationID = 1 WHERE ResourceID = 2

			--- DELETE ---
			DELETE FROM CorporationResources WHERE CorporationID BETWEEN 5 AND 10
		END
END
GO

DELETE FROM Corporations WHERE CorporationID BETWEEN 23 AND 27

-- execs that don't work 
EXEC CorpoCRUD 15, 12, 14, 5 
EXEC CorpoResCRUD 0, 0
EXEC ResourceCRUD 'Ceva', 124, 1, -10, 10

--execs that work
EXEC CorpoCRUD 'SUA', 'Ingrediente', 'Knoll', 100
EXEC ResourceCRUD 'Natural', 'Gas', 4201.99, 69.99, 100
EXEC CorpoResCRUD 81, 1
EXEC CorpoResCRUD 84, 4

SELECT * FROM [dbo].viewCorporations
SELECT * FROM [dbo].viewResources
SELECT * FROM [dbo].viewCorporationResources

SELECT * FROM Corporations
SELECT * FROM Resources
SELECT * FROM CorporationResources

SELECT TOP 1 ResourceID FROM Resources ORDER BY ResourceID ASC
SELECT TOP 1 ResourceID FROM Resources ORDER BY ResourceID DESC