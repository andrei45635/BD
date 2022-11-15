USE [Port]
GO 

--Introduce valoarea implicita SailorName DEFAULT 'Anon'
CREATE PROCEDURE up_to_v2
AS
BEGIN 
ALTER TABLE Sailors 
ADD CONSTRAINT df_name DEFAULT 'Anon' FOR SailorName
PRINT('Introduce constrangere DEFAULT Anon la SailorName')
END

EXEC up_to_v2
