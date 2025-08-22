SELECT Id, Status
FROM Donation
WHERE TRY_CAST(Status AS INT) IS NULL AND Status IS NOT NULL;

-- Set invalid values to 0
UPDATE Donation
SET Status = 0
WHERE TRY_CAST(Status AS INT) IS NULL;

ALTER TABLE Donation ALTER COLUMN Status INT NOT NULL;
