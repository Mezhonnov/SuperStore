USE TrainingDB;

BEGIN TRANSACTION;

-- Create DIM Product table if it doesn't exist
IF OBJECT_ID('dbo.DimProduct', 'U') IS NOT NULL DROP TABLE dbo.DimProduct;

CREATE TABLE dbo.DimProduct (
    ProductSK   INT IDENTITY(1,1) PRIMARY KEY,
    ProductID   NVARCHAR(50) NOT NULL,
    ProductName NVARCHAR(255),
    Category    NVARCHAR(100),
    SubCategory NVARCHAR(100)
);

-- Insert unique ProductIDs with one name per ProductID
INSERT INTO dbo.DimProduct (ProductID, ProductName, Category, SubCategory)
SELECT 
    ProductID,
    MAX(ProductName) AS ProductName,  -- pick one name if multiple exist
    MAX(Category) AS Category,
    MAX(SubCategory) AS SubCategory
FROM dbo.stg_Superstore
WHERE ProductID IS NOT NULL
GROUP BY ProductID;

-- Check rows per ProductID
SELECT ProductID, COUNT(*) AS RowsPerProductID
FROM dbo.DimProduct
GROUP BY ProductID
ORDER BY ProductID;

-- For testing, rollback; replace with COMMIT when ready
COMMIT;