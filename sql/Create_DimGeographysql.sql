USE TrainingDB;
GO

-- Create DimGeography dimension table and populate it with distinct geographical data from the staging table
IF OBJECT_ID('dbo.DimGeography', 'U') IS NOT NULL DROP TABLE dbo.DimGeography;
GO

CREATE TABLE dbo.DimGeography (
    GeographySK INT IDENTITY(1,1) PRIMARY KEY,

    Country     NVARCHAR(100),
    State       NVARCHAR(100),
    City        NVARCHAR(100),
    PostalCode  NVARCHAR(20),
    Region      NVARCHAR(50)
);
GO

INSERT INTO dbo.DimGeography (Country, State, City, PostalCode, Region)
SELECT DISTINCT
    Country,
    State,
    City,
    PostalCode,
    Region
FROM dbo.stg_Superstore;