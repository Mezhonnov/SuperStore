USE TrainingDB;   

BEGIN Transaction;
-- Create DimShipMode dimension table and populate it with distinct ship modes from the staging table
IF OBJECT_ID('dbo.DimShipMode', 'U') IS NOT NULL DROP TABLE dbo.DimShipMode;

CREATE TABLE dbo.DimShipMode (
    ShipModeSK INT IDENTITY(1,1) PRIMARY KEY,
    ShipMode   NVARCHAR(50)
);

INSERT INTO dbo.DimShipMode (ShipMode)
SELECT DISTINCT ShipMode
FROM dbo.stg_Superstore;


COMMIT;