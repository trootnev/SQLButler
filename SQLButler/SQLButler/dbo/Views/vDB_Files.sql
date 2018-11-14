CREATE VIEW [dbo].[vDB_Files]
AS
SELECT dbo.DbFiles.FileLogicalName AS [Логическое имя],
       CASE dbo.DbFiles.FileType WHEN 0 THEN 'Rows' WHEN 1 THEN 'LOG' END AS Тип,
       CAST (dbo.DbFiles.FileSize * 8.0 / 1024.0 AS NUMERIC (10, 2)) AS [Размер в МБ],
       CASE WHEN IsPercentGrowth = 0 THEN CAST (CAST (FileGrowth * 8.0 / 1024.0 AS NUMERIC (10, 2)) AS NVARCHAR (500)) + ' Mb' ELSE CAST (FileGrowth AS NVARCHAR (500)) + ' %' END AS [Прирост],
       dbo.DbFiles.filename AS [Имя Файла],
       CASE WHEN dbo.DbFiles.FileMaxSize = -1
                 OR dbo.DbFiles.FileMaxSize = 268435456 THEN 0 ELSE (CAST (dbo.DbFiles.FileMaxSize * 8.0 / 1024.0 AS NUMERIC (10, 2))) END AS [Лимит МБ],
       dbo.DbFiles.MeasureDate AS [Дата измерения],
       dbo.DbFiles.id,
       dbo.DbFiles.DbId,
       FileGrowth AS Growth_pure,
       IsPercentGrowth,
       S.ServName,
       SrvDB.DbName
FROM   dbo.DbFiles (nolock)
       INNER JOIN
       dbo.SrvDB (nolock)
       ON dbo.DbFiles.DbId = dbo.SrvDB.DbID
       INNER JOIN
       dbo.Servers (nolock) AS s
       ON s.ServID = dbo.SrvDB.SrvID;

