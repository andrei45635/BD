USE [Port]
GO

ALTER PROCEDURE [dbo].[main]
@newVers VARCHAR(50)
AS
BEGIN
DECLARE @nextVers VARCHAR(50)
DECLARE @currentVers INT
SET @currentVers = (SELECT VersionNo FROM Versions)

IF ISNUMERIC(@newVers) != 1
BEGIN
	PRINT('Version must be an INT')
END

SET @newVers = CAST(@newVers AS INT)
IF @newVers < 0 OR @newVers > 5
BEGIN
	PRINT('Versions: 0 to 5')
END

WHILE @currentVers < @newVers
BEGIN 
	SET @currentVers = @currentVers + 1
	SET @nextVers = 'up_to_v' + CONVERT(VARCHAR(50), @currentVers)
	EXEC @nextVers
END	

WHILE @currentVers > @newVers
BEGIN 
	SET @currentVers = @currentVers - 1
	SET @nextVers = 'down_from_v' + CONVERT(VARCHAR(50), @currentVers)
	EXEC @nextVers
END	

PRINT('Suntem la versiunea ' + CONVERT(VARCHAR(50), @newVers))
TRUNCATE TABLE Versions
INSERT INTO Versions(VersionNo) VALUES (@newVers)
END


EXEC main 3
SELECT * FROM Versions