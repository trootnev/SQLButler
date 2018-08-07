CREATE VIEW [dbo].[vSrvRoleMembers]
AS 

WITH RecentCollectionBatchID
AS
(
SELECT batch_id, SrvID,
ROW_NUMBER() OVER (PARTITION BY SrvID ORDER BY CollectionDate Desc) rk

FROM dbo.SrvRoleMembers
Group by batch_id, SrvID,CollectionDate
)

SELECT [RecID]
      ,srm.[SrvID]
      ,srm.[batch_id]
      ,[CollectionDate]
      ,[RoleType]
      ,[Role]
      ,[Member]
      ,[Login]
      ,[SID]
from dbo.SrvRoleMembers srm
JOIN RecentCollectionBatchID rbid on rbid.batch_id = Srm.batch_id
where rbid.rk=1


