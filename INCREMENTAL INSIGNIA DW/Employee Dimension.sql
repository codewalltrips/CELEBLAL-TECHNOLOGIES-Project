CREATE TABLE EmployeeDimension (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    EmployeeRole VARCHAR(100),
    EffectiveStartDate DATETIME,
    EffectiveEndDate DATETIME,
    IsCurrent BIT,
    Lineage_Id BIGINT
);
