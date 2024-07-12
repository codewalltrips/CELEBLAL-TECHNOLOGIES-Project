CREATE PROCEDURE CreateStagingCopy AS
BEGIN
    IF OBJECT_ID('Insignia_staging_copy', 'U') IS NOT NULL
        DROP TABLE Insignia_staging_copy;

    SELECT * INTO Insignia_staging_copy FROM Insignia_staging;
END;
