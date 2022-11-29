USE [Port]
GO 

--Introduce valoarea implicita SailorName DEFAULT 'Anon'
ALTER PROCEDURE [dbo].[up_to_v2]
AS
BEGIN 
ALTER TABLE Sailors 
ADD CONSTRAINT df_name DEFAULT 'Anon' FOR SailorName
PRINT('SailorName -> constrangere DEFAULT ''Anon''')
END

EXEC up_to_v2
