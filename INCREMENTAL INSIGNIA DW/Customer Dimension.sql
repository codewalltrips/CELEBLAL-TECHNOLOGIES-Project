CREATE TABLE CustomerDimension (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(100),
    CustomerAddress VARCHAR(255),
    CustomerEmail VARCHAR(100),
    EffectiveStartDate DATETIME,
    EffectiveEndDate DATETIME,
    IsCurrent BIT,
    Lineage_Id BIGINT
);
