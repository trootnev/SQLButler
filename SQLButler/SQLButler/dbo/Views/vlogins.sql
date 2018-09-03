CREATE VIEW [dbo].[vlogins]
AS
SELECT j.collectionDate,
       s.ServName,
       j.[LoginName],
       j.[Pass],
       j.[sid],
       j.[Comment],
       j.[Owner],
       j.srvid,
	   j.is_current

FROM   SrvLogins (nolock) AS j
       INNER JOIN
       Servers (nolock) AS s
       ON j.srvid = s.ServID;

