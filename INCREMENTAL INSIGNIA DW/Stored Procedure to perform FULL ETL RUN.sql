CREATE PROCEDURE FullETLRun AS
BEGIN
    DECLARE @StartDateTime DATETIME = GETDATE();

    -- Step 1: Insert a new entry into the lineage table
    INSERT INTO Lineage (Source_System, Load_Stat_Datetime)
    VALUES ('Insignia System', @StartDateTime);

    -- Step 2: Perform the incremental load
    EXEC IncrementalLoad;

    -- Step 3: Perform reconciliation
    EXEC Reconciliation;

    -- Step 4: Update the load end datetime
    DECLARE @EndDateTime DATETIME = GETDATE();
    DECLARE @Lineage_Id BIGINT = (SELECT MAX(Lineage_Id) FROM Lineage);

    UPDATE Lineage
    SET Load_EndDatetime = @EndDateTime
    WHERE Lineage_Id = @Lineage_Id;
END;
