CREATE PROCEDURE LoadFact AS
BEGIN
    DECLARE @Lineage_Id BIGINT = (SELECT MAX(Lineage_Id) FROM Lineage);

    INSERT INTO SalesFact (SalesID, ProductKey, CustomerKey, EmployeeKey, GeographyKey, DateKey, Quantity, TotalSales, Lineage_Id)
    SELECT 
        SalesID,
        (SELECT ProductKey FROM ProductDimension WHERE ProductID = st.ProductID),
        (SELECT CustomerKey FROM CustomerDimension WHERE CustomerID = st.CustomerID AND IsCurrent = 1),
        (SELECT EmployeeKey FROM EmployeeDimension WHERE EmployeeID = st.EmployeeID AND IsCurrent = 1),
        (SELECT GeographyKey FROM GeographyDimension WHERE GeographyID = st.GeographyID),
        (SELECT DateKey FROM DateDimension WHERE Date = st.SalesDate),
        Quantity,
        TotalSales,
        @Lineage_Id
    FROM Insignia_staging_copy st;
END;