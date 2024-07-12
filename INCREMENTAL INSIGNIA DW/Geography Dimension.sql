CREATE TABLE GeographyDimension (
    GeographyKey INT IDENTITY(1,1) PRIMARY KEY,
    GeographyID INT,
    Country VARCHAR(100),
    State VARCHAR(100),
    City VARCHAR(100),
    Population INT,
    PreviousPopulation INT,
    Lineage_Id BIGINT
);
