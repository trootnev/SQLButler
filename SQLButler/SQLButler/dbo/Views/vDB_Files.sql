CREATE VIEW [dbo].[vDB_Files]
AS
SELECT dbo.DbFiles.name AS [Логическое имя],
       CASE dbo.DbFiles.type WHEN 0 THEN 'Rows' WHEN 1 THEN 'LOG' END AS Тип,
       CAST (dbo.DbFiles.size * 8.0 / 1024.0 AS NUMERIC (10, 2)) AS [Размер в МБ],
       CASE WHEN is_percent_growth = 0 THEN CAST (CAST (growth * 8.0 / 1024.0 AS NUMERIC (10, 2)) AS NVARCHAR (500)) + ' Mb' ELSE CAST (growth AS NVARCHAR (500)) + ' %' END AS [Прирост],
       dbo.DbFiles.filename AS [Имя Файла],
       CASE WHEN dbo.DbFiles.maxsize = -1
                 OR dbo.DbFiles.maxsize = 268435456 THEN 0 ELSE (CAST (dbo.DbFiles.maxsize * 8.0 / 1024.0 AS NUMERIC (10, 2))) END AS [Лимит МБ],
       dbo.DbFiles.MeasureDate AS [Дата измерения],
       dbo.DbFiles.id,
       dbo.DbFiles.db_id,
       growth AS Growth_pure,
       is_percent_growth,
       S.ServName,
       SrvDB.DbName
FROM   dbo.DbFiles
       INNER JOIN
       dbo.SrvDB
       ON dbo.DbFiles.db_id = dbo.SrvDB.DbID
       INNER JOIN
       dbo.Servers AS s
       ON s.ServID = dbo.SrvDB.SrvID;

