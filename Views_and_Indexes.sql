USE [Port]
GO

-- View for the Corporations table
-- Creating a non-clustered index on it 

CREATE OR ALTER VIEW [dbo].viewCorporations AS
	SELECT CorporationCountry, CorpoName FROM Corporations 
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'IX_CorpoCountryName')
	DROP INDEX IX_CorpoCountryName ON Corporations;
GO
CREATE NONCLUSTERED INDEX IX_CorpoCountryName ON Corporations(CorporationCountry, CorpoName);
GO

-- View for the Resources table
-- Creating a non-clustered index on it 

CREATE OR ALTER VIEW [dbo].viewResources AS
	SELECT ResourceName, ResourcePrice FROM Resources 
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'IX_ResourceNamePrice')
	DROP INDEX IX_ResourceNamePrice ON Resources;
GO
CREATE NONCLUSTERED INDEX IX_ResourceNamePrice ON Resources(ResourceName, ResourcePrice);
GO

-- View for the CorporationResources table
-- Creating a non-clustered index on it 

CREATE OR ALTER VIEW [dbo].viewCorporationResources AS
	SELECT CorporationID, ResourceID FROM CorporationResources 
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'IX_CorpoResoID')
	DROP INDEX IX_CorpoResoID ON CorporationResources;
GO
CREATE NONCLUSTERED INDEX IX_CorpoResoID ON CorporationResources(CorporationID, ResourceID);
GO

SELECT * FROM viewCorporations
SELECT * FROM viewResources
SELECT * FROM viewCorporationResources