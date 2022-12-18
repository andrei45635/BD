USE [Port]
GO

-- Validation function for the Corporations table 
-- Corporation Country, Corporation Goods, Corporation Name
-- All varchar, Country is by default 'Multinational' and Name is by default 'Undisclosed'

-- functie de validare pt campurile Corporations
-- campurile au valori default, insa daca sunt introduse valori null atunci se returneaza eroare
CREATE OR ALTER FUNCTION [dbo].validareCampuriCorporatie (@camp VARCHAR(50))
RETURNS BIT
AS
BEGIN
	DECLARE @flag BIT
	IF LEN(@camp) < 0 OR ISNUMERIC(@camp) = 1
	BEGIN
		SET @flag = 1
	END

	RETURN @flag;
END
GO

-- functie de validare pt CorporationID
CREATE OR ALTER FUNCTION [dbo].validareCorpoID (@CorpoID INT)
RETURNS BIT
AS
BEGIN
	DECLARE @flag INT
	DECLARE @begin INT
	DECLARE @end INT
	
	SELECT TOP 1 @begin = CorporationID FROM Corporations ORDER BY CorporationID ASC
	SELECT TOP 1 @end = CorporationID FROM Corporations ORDER BY CorporationID DESC
	
	IF @CorpoID BETWEEN @begin AND @end
	BEGIN
		SET @flag = 1
	END

	RETURN @flag;
END
GO