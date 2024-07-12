CREATE TABLE SalesFact (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    SalesID INT,
    ProductKey INT,
    CustomerKey INT,
    EmployeeKey INT,
    GeographyKey INT,
    DateKey INT,
    Quantity INT,
    TotalSales DECIMAL(18, 2),
    Lineage_Id BIGINT
);
