CREATE TABLE DateDimension (
    DateKey INT PRIMARY KEY,
    Date DATE,
    Day_Number INT,
    Month_Name VARCHAR(50),
    Short_Month CHAR(3),
    Calendar_Month_Number INT,
    Calendar_Year INT,
    Fiscal_Month_Number INT,
    Fiscal_Year INT,
    Week_Number INT
);

-- Populate Date Dimension
DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate DATE = '2023-12-31';

INSERT INTO DateDimension (DateKey, Date, Day_Number, Month_Name, Short_Month, Calendar_Month_Number, Calendar_Year, Fiscal_Month_Number, Fiscal_Year, Week_Number)
SELECT 
    CAST(CONVERT(VARCHAR, @StartDate, 112) AS INT) AS DateKey,
    @StartDate AS Date,
    DATEPART(DAY, @StartDate) AS Day_Number,
    DATENAME(MONTH, @StartDate) AS Month_Name,
    LEFT(DATENAME(MONTH, @StartDate), 3) AS Short_Month,
    DATEPART(MONTH, @StartDate) AS Calendar_Month_Number,
    DATEPART(YEAR, @StartDate) AS Calendar_Year,
    CASE 
        WHEN DATEPART(MONTH, @StartDate) >= 7 THEN DATEPART(MONTH, @StartDate) - 6
        ELSE DATEPART(MONTH, @StartDate) + 6
    END AS Fiscal_Month_Number,
    CASE 
        WHEN DATEPART(MONTH, @StartDate) >= 7 THEN DATEPART(YEAR, @StartDate)
        ELSE DATEPART(YEAR, @StartDate) - 1
    END AS Fiscal_Year,
    DATEPART(WEEK, @StartDate) AS Week_Number
FROM
    (SELECT @StartDate + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS Date
     FROM master.dbo.spt_values) AS Dates
WHERE @StartDate <= @EndDate;
