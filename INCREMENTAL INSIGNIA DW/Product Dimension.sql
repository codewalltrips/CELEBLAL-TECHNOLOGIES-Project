CREATE TABLE ProductDimension (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    ProductCategory VARCHAR(100),
    ProductPrice DECIMAL(18, 2),
    Lineage_Id BIGINT
);
