USE [Port]
GO

--Readuce la versiunea 5
CREATE PROCEDURE down_from_v4
AS
BEGIN
ALTER TABLE Visitor
DROP CONSTRAINT fk_Visitor_Sailor
PRINT('Am sters cheia straina SailorID')
END

EXEC down_from_v4