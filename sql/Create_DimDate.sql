USE TrainingDB;

-- Create DimDate dimension table and populate it with distinct dates from the OrderDate column in the staging table
IF OBJECT_ID('dbo.DimDate', 'U') IS NOT NULL DROP TABLE dbo.DimDate;

CREATE TABLE dbo.DimDate (
    DateSK      INT PRIMARY KEY,
    FullDate    DATE NOT NULL,
    Year        INT NOT NULL,
    Quarter     INT NOT NULL,
    Month       INT NOT NULL,
    MonthName   NVARCHAR(20),
    Day         INT NOT NULL,
    DayOfWeek   INT NOT NULL,
    
);

DECLARE @StartDate DATE = '2014-01-01';
DECLARE @EndDate DATE = '2026-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO dbo.DimDate (
        DateSK, FullDate, Year, Quarter, Month, MonthName, Day, DayOfWeek
    )
    SELECT 
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
        @StartDate,
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DAY(@StartDate),
        DATEPART(WEEKDAY, @StartDate)

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
