USE TrainingDB;

BEGIN transaction;

IF OBJECT_ID('dbo.FactSales', 'U') IS NOT NULL DROP TABLE dbo.FactSales;

-- Create FactSales fact table and populate it by joining the staging table with dimension tables to get the corresponding surrogate keys

CREATE TABLE dbo.FactSales (
    SalesID       INT IDENTITY(1,1) PRIMARY KEY,
    OrderDateSK   INT NOT NULL,
    ShipDateSK    INT NOT NULL,
    CustomerSK    INT NOT NULL,
    GeographySK   INT NOT NULL,
    ProductSK     INT NOT NULL,
    ShipModeSK    INT NOT NULL, 
    
    OrderID NVARCHAR(50),
    Sales   MONEY,
    Quantity      INT,
    Discount      FLOAT,
    Profit        MONEY,

    -- Constraint FK
    CONSTRAINT FK_OrderDate   FOREIGN KEY (OrderDateSK) REFERENCES dbo.DimDate(DateSK),
    CONSTRAINT FK_ShipDate    FOREIGN KEY (ShipDateSK)  REFERENCES dbo.DimDate(DateSK),
    CONSTRAINT FK_Customer    FOREIGN KEY (CustomerSK)  REFERENCES dbo.DimCustomer(CustomerSK),
    CONSTRAINT FK_Geography   FOREIGN KEY (GeographySK) REFERENCES dbo.DimGeography(GeographySK),
    CONSTRAINT FK_Product     FOREIGN KEY (ProductSK)   REFERENCES dbo.DimProduct(ProductSK),
    CONSTRAINT FK_ShipMode    FOREIGN KEY (ShipModeSK)  REFERENCES dbo.DimShipMode(ShipModeSK)
);

-- Load data
INSERT INTO dbo.FactSales (
    OrderDateSK, ShipDateSK, CustomerSK, GeographySK, ProductSK, ShipModeSK,
    OrderID, Sales, Quantity, Discount, Profit
)
SELECT 
    CONVERT(INT, FORMAT(stg.OrderDate, 'yyyyMMdd')),
    ISNULL(CONVERT(INT, FORMAT(stg.ShipDate, 'yyyyMMdd')), 19000101),
    c.CustomerSK,
    g.GeographySK,
    p.ProductSK,
    sm.ShipModeSK, 
    stg.OrderID,
    stg.Sales,
    stg.Quantity,
    stg.Discount,
    stg.Profit
FROM dbo.stg_Superstore stg
INNER JOIN dbo.DimCustomer c ON stg.CustomerID = c.CustomerID
INNER JOIN dbo.DimProduct p  ON stg.ProductID = p.ProductID
INNER JOIN dbo.DimShipMode sm ON stg.ShipMode = sm.ShipMode
INNER JOIN dbo.DimGeography g 
    ON stg.PostalCode = g.PostalCode 
    AND stg.City = g.City 
    AND stg.State = g.State;
commit transaction;