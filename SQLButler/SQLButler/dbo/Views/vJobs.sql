CREATE VIEW [dbo].[vJobs]
AS
SELECT j.id,
       s.ServName,
       j.job_name,
       j.category,
       CASE j.IsSystem WHEN 0 THEN 'USER' WHEN 1 THEN 'SYSTEM' END AS IsSystem,
       CASE LASTRESULT WHEN 1 THEN 'Success' WHEN 0 THEN 'FAILURE!' END AS lastresult,
       j.lastrundate,
       j.catOverride AS CatOverride
FROM   Srvjobs AS j
       INNER JOIN
       Servers AS s
       ON j.srvid = s.ServID;

