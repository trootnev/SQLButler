CREATE VIEW [dbo].[vJobs]
AS
SELECT j.id,
       s.ServName,
       j.JobName,
       j.JobCategory,
       CASE j.IsSystem WHEN 0 THEN 'USER' WHEN 1 THEN 'SYSTEM' END AS IsSystem,
       CASE LastOutcome WHEN 1 THEN 'Success' WHEN 0 THEN 'FAILURE!' END AS LastOutcome,
       j.LastRunDate,
       j.CatOverride AS CatOverride
FROM   Srvjobs (nolock) AS j
       INNER JOIN
       Servers (nolock) AS s
       ON j.SrvId = s.ServID;

