CREATE PROCEDURE Reconciliation AS
BEGIN
    DECLARE @RowsAtSource INT;
    DECLARE @RowsAtDestinationFact INT;
    DECLARE @LoadStatus BIT;
    DECLARE @Lineage_Id BIGINT = (SELECT MAX(Lineage_Id) FROM Lineage);

    -- Count rows at source
    SELECT @RowsAtSource = COUNT(*) FROM Insignia_staging;

    -- Count rows at destination fact
    SELECT @RowsAtDestinationFact = COUNT(*) FROM SalesFact WHERE Lineage_Id = @Lineage_Id;

    -- Set load status
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
END;
