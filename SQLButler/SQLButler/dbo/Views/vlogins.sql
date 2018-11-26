CREATE VIEW [dbo].[vLogins]
AS
SELECT j.RecId,
		j.CollectionDate,
       s.ServName,
       j.[LoginName],
       j.[SID],
       j.[Comment],
       j.OwnerID,
       j.SrvID,
	   j.IsCurrent

FROM   SrvLogins (nolock) AS j
       INNER JOIN
       Servers (nolock) AS s
       ON j.srvid = s.ServID;

