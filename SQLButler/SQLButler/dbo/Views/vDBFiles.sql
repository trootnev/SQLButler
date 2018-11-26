CREATE VIEW [dbo].[vDBFiles]
AS
SELECT dbo.DbFiles.FileLogicalName AS LogicalName,
       CASE dbo.DbFiles.FileType WHEN 0 THEN 'Rows' WHEN 1 THEN 'LOG' END AS FileType,
       CAST (dbo.DbFiles.FileSize * 8.0 / 1024.0 AS NUMERIC (10, 2)) AS [FileSizeMb],
       CASE WHEN IsPercentGrowth = 0 THEN CAST (CAST (FileGrowth * 8.0 / 1024.0 AS NUMERIC (10, 2)) AS NVARCHAR (500)) + ' Mb' ELSE CAST (FileGrowth AS NVARCHAR (500)) + ' %' END AS FileGrowth,
       dbo.DbFiles.filename AS [FileName],
       CASE WHEN dbo.DbFiles.FileMaxSize = -1
                 OR dbo.DbFiles.FileMaxSize = 268435456 THEN 0 ELSE (CAST (dbo.DbFiles.FileMaxSize * 8.0 / 1024.0 AS NUMERIC (10, 2))) END AS [SizeLimitMb],
       dbo.DbFiles.MeasureDate AS [CollectionDate],
       dbo.DbFiles.ID,
       dbo.DbFiles.DbID,
       FileGrowth AS GrowthRaw,
       IsPercentGrowth,
       S.ServName,
       SrvDB.DbName
FROM   dbo.DbFiles (nolock)
       INNER JOIN
       dbo.SrvDB (nolock)
       ON dbo.DbFiles.DbID = dbo.SrvDB.DbID
       INNER JOIN
       dbo.Servers (nolock) AS s
       ON s.ServID = dbo.SrvDB.SrvID;

