CREATE PROCEDURE IncrementalLoad AS
BEGIN
    -- Step 1: Create a copy of the Insignia_staging table
    EXEC CreateStagingCopy;

    -- Step 2: Load data from Insignia_staging_copy to Dimensions
    EXEC LoadDimensions;

    -- Step 3: Load data into Fact Table
    EXEC LoadFact;

    -- Step 4: Insert data from Insignia_incremental into Insignia_staging_copy
    TRUNCATE TABLE Insignia_staging_copy;

    INSERT INTO Insignia_staging_copy
    SELECT * FROM Insignia_incremental;
    
    -- Step 5: Load data from Insignia_staging_copy to Dimensions again for incremental data
    EXEC LoadDimensions;

    -- Step 6: Load data into Fact Table again for incremental data
    EXEC LoadFact;
END;

OR

CREATE PROCEDURE IncrementalLoad AS
BEGIN
    DECLARE @Lineage_Id BIGINT;
    DECLARE @StartDateTime DATETIME = GETDATE();
    DECLARE @RowsAtSource INT;
    DECLARE @RowsAtDestinationFact INT;
    DECLARE @LoadStatus BIT;

    -- Step 1: Create a copy of the Insignia_staging table
    IF OBJECT_ID('Insignia_staging_copy', 'U') IS NOT NULL
        DROP TABLE Insignia_staging_copy;

    SELECT * INTO Insignia_staging_copy FROM Insignia_staging;

    -- Step 2: Load data from Insignia_staging_copy to Dimensions
    EXEC LoadDimensions;

    -- Step 3: Load data into Fact Table
    EXEC LoadFact;

    -- Step 4: Insert data from Insignia_incremental into Insignia_staging_copy
    TRUNCATE TABLE Insignia_staging_copy;
    INSERT INTO Insignia_staging_copy SELECT * FROM Insignia_incremental;

    -- Step 5: Load data from Insignia_staging_copy to Dimensions again for incremental data
    EXEC LoadDimensions;

    -- Step 6: Load data into Fact Table again for incremental data
    EXEC LoadFact;

    -- Reconciliation
    SELECT @RowsAtSource = COUNT(*) FROM Insignia_staging;
    SELECT @RowsAtDestinationFact = COUNT(*) FROM SalesFact WHERE Lineage_Id = @Lineage_Id;

    IF @RowsAtSource = @RowsAtDestinationFact
        SET @LoadStatus = 1;
    ELSE
        SET @LoadStatus = 0;

    -- Update lineage table with reconciliation results
    UPDATE Lineage
    SET Rows_at_Source = @RowsAtSource,
        Rows_at_Destination_Fact = @RowsAtDestinationFact,
        Load_Status = @LoadStatus
    WHERE Lineage_Id = @Lineage_Id;
    
    DECLARE @EndDateTime DATETIME = GETDATE();
    UPDATE Lineage
    SET Load_EndDatetime = @EndDateTime
    WHERE Lineage_Id = @Lineage_Id;
END;
