CREATE PROCEDURE [dbo].[CheckConfig4Changes]
AS
WITH   CTE (SrvID, RK, timestamp, name, value, value_in_use)
AS     (SELECT SrvID,
               RANK() OVER (PARTITION BY SrvID, ConfigurationName ORDER BY CollectionDate DESC) AS RK,
               [CollectionDate],
               ConfigurationName,
               ConfigurationValue,
               ConfigurationValueInUse
        FROM   [dbo].[InstanceConfiguration]
        WHERE  CollectionDate > dateadd(dd, -7, getdate()))

INSERT INTO dbo.ConfigChanges
(SrvID, Parameter, [DetectionTime], NewValue,ValueInUse,PrevTimestamp, PrevValue, PrevValueInUse)
SELECT c1.SrvID,
       c1.name AS Parameter,
       c1.timestamp AS Change_Detected_Time,
       c1.value AS New_Value,
       c1.value_in_use AS Value_In_Use,
       c2.timestamp AS Prev_Timestamp,
       c2.value AS Prev_Value,
       c2.value_in_use AS Prev_Value_in_Use
FROM   CTE AS c1
       INNER JOIN
       CTE AS c2
       ON c1.RK + 1 = c2.RK
          AND c1.SrvID = c2.SrvID
          AND c1.name = c2.name
WHERE  c1.RK = 1
       AND (c1.value <> c2.value
            OR c1.value_in_use <> c2.value_in_use);

