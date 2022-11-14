USE [Port]
GO

--Readuce la versiunea 5
CREATE PROCEDURE down_from_v5
AS
BEGIN
ALTER TABLE Visitor
DROP CONSTRAINT fk_Visitor_Sailor
END

EXEC down_from_v5