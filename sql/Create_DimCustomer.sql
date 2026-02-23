USE TrainingDB;
GO
-- Create DimCustomer dimension table and populate it with distinct customers from the staging table
IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL DROP TABLE dbo.DimCustomer;
GO

CREATE TABLE dbo.DimCustomer (
    CustomerSK   INT IDENTITY(1,1) PRIMARY KEY, 
    CustomerID   NVARCHAR(20) NOT NULL,          
    CustomerName NVARCHAR(100),
    Segment      NVARCHAR(50)
);
GO

INSERT INTO dbo.DimCustomer (CustomerID, CustomerName, Segment)
SELECT DISTINCT CustomerID, CustomerName, Segment
FROM dbo.stg_Superstore
WHERE CustomerID IS NOT NULL;