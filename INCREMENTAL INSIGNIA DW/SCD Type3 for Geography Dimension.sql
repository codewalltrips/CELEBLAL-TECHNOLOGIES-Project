-- Geography Dimension SCD Type 3
INSERT INTO GeographyDimension (GeographyID, Country, State, City, Population, PreviousPopulation, Lineage_Id)
SELECT DISTINCT GeographyID, Country, State, City, Population, NULL, @Lineage_Id
FROM Insignia_staging_copy st
WHERE NOT EXISTS (
    SELECT 1 
    FROM GeographyDimension gd 
    WHERE gd.GeographyID = st.GeographyID
);

UPDATE gd
SET PreviousPopulation = gd.Population, Population = st.Population
FROM GeographyDimension gd
JOIN Insignia_staging_copy st ON gd.GeographyID = st.GeographyID
WHERE gd.Population != st.Population;
