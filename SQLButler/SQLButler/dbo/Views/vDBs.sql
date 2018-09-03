CREATE VIEW [dbo].[vDBs]
AS
SELECT dbo.SrvDB.DbID AS [ID базы],
       dbo.Servers.ServName AS [Имя сервера],
       dbo.SrvDB.DbName AS [Имя БД],
       dbo.SrvDB.DbComment AS [Описание БД],
       dbo.SrvDB.DbGroup AS [Группа БД],
       dbo.SrvDB.DBSize AS [Размер Базы],
       dbo.SrvDB.BackupNeeded AS Бэкап,
       dbo.SrvDB.BackupMod AS [Режим бэкапа],
       dbo.SrvDB.RecMod,
       dbo.RecModel.RM AS [Модель восстановления],
       dbo.SrvDB.Order4Create AS [Заявка на создание],
       dbo.SrvDB.OrderDate AS [Дата заявки],
       dbo.SrvDB.SizeOrdered_GB AS [Заявленный размер],
       dbo.SrvDB.ImpLevel AS [Уровень важности],
       dbo.SrvDB.SrvID,
       dbo.SrvDB.Customer
FROM   dbo.RecModel (nolock)
       INNER JOIN
       dbo.SrvDB (nolock)
       ON dbo.RecModel.id = dbo.SrvDB.RecMod
       LEFT OUTER JOIN
       dbo.Servers (nolock)
       ON dbo.SrvDB.SrvID = dbo.Servers.ServID;

