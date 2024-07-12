-- Employee Dimension SCD Type 2
INSERT INTO EmployeeDimension (EmployeeID, EmployeeName, EmployeeRole, EffectiveStartDate, EffectiveEndDate, IsCurrent, Lineage_Id)
SELECT DISTINCT EmployeeID, EmployeeName, EmployeeRole, GETDATE(), NULL, 1, @Lineage_Id
FROM Insignia_staging_copy st
WHERE NOT EXISTS (
    SELECT 1 
    FROM EmployeeDimension ed 
    WHERE ed.EmployeeID = st.EmployeeID AND ed.IsCurrent = 1
);

UPDATE ed
SET EffectiveEndDate = GETDATE(), IsCurrent = 0
FROM EmployeeDimension ed
JOIN Insignia_staging_copy st ON ed.EmployeeID = st.EmployeeID
WHERE ed.IsCurrent = 1
AND (ed.EmployeeName != st.EmployeeName OR ed.EmployeeRole != st.EmployeeRole);

INSERT INTO EmployeeDimension (EmployeeID, EmployeeName, EmployeeRole, EffectiveStartDate, EffectiveEndDate, IsCurrent, Lineage_Id)
SELECT DISTINCT EmployeeID, EmployeeName, EmployeeRole, GETDATE(), NULL, 1, @Lineage_Id
FROM Insignia_staging_copy st
WHERE EXISTS (
    SELECT 1 
    FROM EmployeeDimension ed 
    WHERE ed.EmployeeID = st.EmployeeID AND ed.IsCurrent = 0
);

-- Customer Dimension SCD Type 2
INSERT INTO CustomerDimension (CustomerID, CustomerName, CustomerAddress, CustomerEmail, EffectiveStartDate, EffectiveEndDate, IsCurrent, Lineage_Id)
SELECT DISTINCT CustomerID, CustomerName, CustomerAddress, CustomerEmail, GETDATE(), NULL, 1, @Lineage_Id
FROM Insignia_staging_copy st
WHERE NOT EXISTS (
    SELECT 1 
    FROM CustomerDimension cd 
    WHERE cd.CustomerID = st.CustomerID AND cd.IsCurrent = 1
);

UPDATE cd
SET EffectiveEndDate = GETDATE(), IsCurrent = 0
FROM CustomerDimension cd
JOIN Insignia_staging_copy st ON cd.CustomerID = st.CustomerID
WHERE cd.IsCurrent = 1
AND (cd.CustomerName != st.CustomerName OR cd.CustomerAddress != st.CustomerAddress OR cd.CustomerEmail != st.CustomerEmail);

INSERT INTO CustomerDimension (CustomerID, CustomerName, CustomerAddress, CustomerEmail, EffectiveStartDate, EffectiveEndDate, IsCurrent, Lineage_Id)
SELECT DISTINCT CustomerID, CustomerName, CustomerAddress, CustomerEmail, GETDATE(), NULL, 1, @Lineage_Id
FROM Insignia_staging_copy st
WHERE EXISTS (
    SELECT 1 
    FROM CustomerDimension cd 
    WHERE cd.CustomerID = st.CustomerID AND cd.IsCurrent = 0
);
