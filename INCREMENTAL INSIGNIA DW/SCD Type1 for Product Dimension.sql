-- Product Dimension SCD Type 1
INSERT INTO ProductDimension (ProductID, ProductName, ProductCategory, ProductPrice, Lineage_Id)
SELECT DISTINCT ProductID, ProductName, ProductCategory, ProductPrice, @Lineage_Id
FROM Insignia_staging_copy st
WHERE NOT EXISTS (
    SELECT 1 
    FROM ProductDimension pd 
    WHERE pd.ProductID = st.ProductID
);

UPDATE pd
SET pd.ProductName = st.ProductName, pd.ProductCategory = st.ProductCategory, pd.ProductPrice = st.ProductPrice, pd.Lineage_Id = @Lineage_Id
FROM ProductDimension pd
JOIN Insignia_staging_copy st ON pd.ProductID = st.ProductID;
