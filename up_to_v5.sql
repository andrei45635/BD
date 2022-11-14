USE [Port]
GO

--Adauga constrangere de foreign key la tabela Visitor
CREATE PROCEDURE up_to_v5
AS
BEGIN 
ALTER TABLE Visitor
ADD CONSTRAINT fk_Visitor_Sailor FOREIGN KEY(SailorID) REFERENCES Sailors(SailorID)
END

EXEC up_to_v5
