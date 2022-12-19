USE [Port]
GO

-- Validation function for the Resources table
-- Type, Name both varchar
-- Type can only be Natural, Synthetic, Other
-- Name -> default Unspecified
-- Weight is a float, between 10 and 9999
-- Price is a float that can't be null 

-- valideaza tipul resursei
-- tipul nu poate fi diferit de Natural, Synthetic sau Other
-- tipul trebuie sa fie varchar
CREATE OR ALTER FUNCTION [dbo].validareTipResursa (@tip VARCHAR(50))
RETURNS BIT
AS
BEGIN
	DECLARE @flag BIT
	IF @tip != 'Natural' OR @tip != 'Synthetic' OR @tip != 'Other' OR ISNUMERIC(@tip) = 1
	BEGIN 
		SET @flag = 1
	END
	RETURN @flag;
END
GO

-- valideaza numele resursei
-- numele are deja valoare default dar nu poate fi nula
-- numele trebuie sa fie varchar
CREATE OR ALTER FUNCTION [dbo].validareNumeResursa (@nume VARCHAR(50))
RETURNS BIT
AS
BEGIN
	DECLARE @flag BIT
	IF LEN(@nume) < 0 OR ISNUMERIC(@nume) = 1
	BEGIN
		SET @flag = 1
	END
	RETURN @flag;
END
GO

-- valideaza greutatea resursei
-- greutatea trebuie sa fie intre 10 si 9999
-- greutatea trebuie sa fie float 
-- IF @weight NOT BETWEEN 10 AND 9999 OR ISNUMERIC(@weight) = 0

CREATE OR ALTER FUNCTION [dbo].validareGreutateResursa (@weight FLOAT)
RETURNS BIT
AS
BEGIN
	DECLARE @flag BIT
	IF @weight NOT BETWEEN 10 AND 9999 OR NOT (FLOOR(@weight) <> CEILING(@weight))
	BEGIN
		SET @flag = 1
	END
	RETURN @flag;
END
GO

-- valideaza pretul resursei
-- pretul trebuie sa fie float si not null
-- IF ISNUMERIC(@price) = 0 OR @price < 0
CREATE OR ALTER FUNCTION [dbo].validarePretResursa (@price FLOAT)
RETURNS BIT
AS
BEGIN
	DECLARE @flag BIT
	IF NOT (FLOOR(@price) <> CEILING (@price)) AND @price > 0
	BEGIN
		SET @flag = 1
	END
	RETURN @flag;
END
GO

-- functie de validare pt ResourceID
CREATE OR ALTER FUNCTION [dbo].validareResourceID (@ResoID INT)
RETURNS BIT
AS
BEGIN
	DECLARE @flag INT
	DECLARE @begin INT
	DECLARE @end INT

	SELECT TOP 1 @begin = ResourceID FROM Resources ORDER BY ResourceID ASC
	SELECT TOP 1 @end = ResourceID FROM Resources ORDER BY ResourceID DESC
	
	IF @ResoID NOT BETWEEN @begin AND @end
	BEGIN
		SET @flag = 1
	END

	RETURN @flag;
END
GO