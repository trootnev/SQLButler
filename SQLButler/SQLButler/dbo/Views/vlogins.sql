CREATE VIEW [dbo].[vlogins]
AS
SELECT j.collectionDate,
       s.ServName,
       j.[LoginName],
       j.[sid],
       j.[Comment],
       j.OwnerId,
       j.SrvId,
	   j.IsCurrent

FROM   SrvLogins (nolock) AS j
       INNER JOIN
       Servers (nolock) AS s
       ON j.srvid = s.ServID;

