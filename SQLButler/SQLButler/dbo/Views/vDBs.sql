CREATE VIEW [dbo].[vDBs]
AS
SELECT dbo.SrvDB.DbID AS [DatabaseID],
       dbo.Servers.ServName AS [ServerName],
       dbo.SrvDB.DbName AS [DatabaseName],
       dbo.SrvDB.DbComment AS [DBDescription],
       dbg.GroupName AS [DbGroupName],
       dbo.SrvDB.DBSize AS [DBSizeGb],
       dbo.SrvDB.BackupNeeded AS [BackupNeeded],
       dbo.SrvDB.BackupMod AS [BackupType],
       dbo.RecModel.RM AS [RecoveryModel],
       dbo.SrvDB.CMID AS [Order Number],
       dbo.SrvDB.CMDate AS [Order Date],
       dbo.SrvDB.PlanedSizeGB AS [PlannedSizeGB],
       dbo.SrvDB.Impact AS [ImpactLevel],
       dbo.SrvDB.SrvID,
       dep.DepName + ', ' +V.VendorName as [OwningDepartment]
FROM   dbo.RecModel (nolock)
       INNER JOIN
       dbo.SrvDB (nolock)
       ON dbo.RecModel.id = dbo.SrvDB.RecMod
       LEFT OUTER JOIN
       dbo.Servers (nolock)
       ON dbo.SrvDB.SrvID = dbo.Servers.ServID
	   LEFT JOIN dbo.DbGroup dbg on dbo.SrvDB.DbGroupID = dbg.id
	   LEFT JOIN dbo.Department dep on SrvDB.CustomerDepartmentID = dep.DepID
	   LEFT JOIN dbo.Vendors V on dep.DepCompanyID = V.VendorID

