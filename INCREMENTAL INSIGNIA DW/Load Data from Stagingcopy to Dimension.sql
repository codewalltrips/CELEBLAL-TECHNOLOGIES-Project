CREATE PROCEDURE LoadDimensions AS
BEGIN
    DECLARE @Lineage_Id BIGINT = (SELECT MAX(Lineage_Id) FROM Lineage);

    -- Load Product Dimension
    INSERT INTO ProductDimension (ProductID, ProductName, ProductCategory, ProductPrice, Lineage_Id)
    SELECT DISTINCT ProductID, ProductName, ProductCategory, ProductPrice, @Lineage_Id
    FROM Insignia_staging_copy;
    
    -- Load Customer Dimension (SCD Type 2)
    -- Similar logic for Employee and Geography Dimension

    -- Load Customer Dimension
    MERGE CustomerDimension AS target
    USING (SELECT DISTINCT CustomerID, CustomerName, CustomerAddress, CustomerEmail FROM Insignia_staging_copy) AS source
    ON (target.CustomerID = source.CustomerID AND target.IsCurrent = 1)
    WHEN MATCHED AND (target.CustomerName != source.CustomerName OR target.CustomerAddress != source.CustomerAddress OR target.CustomerEmail != source.CustomerEmail)
    THEN 
        UPDATE SET target.EffectiveEndDate = GETDATE(), target.IsCurrent = 0
    WHEN NOT MATCHED BY TARGET 
    THEN
        INSERT (CustomerID, CustomerName, CustomerAddress, CustomerEmail, EffectiveStartDate, EffectiveEndDate, IsCurrent, Lineage_Id)
        VALUES (source.CustomerID, source.CustomerName, source.CustomerAddress, source.CustomerEmail, GETDATE(), NULL, 1, @Lineage_Id);
    
    -- Similar logic for Employee Dimension (SCD Type 2)
    -- Similar logic for Geography Dimension (SCD Type 3)
END;
