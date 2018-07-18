CREATE VIEW [dbo].[vlogins]
AS
SELECT j.collectionDate,
       s.ServName,
       j.[LoginName],
       j.[Pass],
       j.[sid],
       j.[Comment],
       j.[Owner],
       j.srvid
FROM   SrvLogins AS j
       INNER JOIN
       Servers AS s
       ON j.srvid = s.ServID;

