/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW dbo.vSrvVolumes
as
SELECT 
       s.[ServID]
	  ,s.[ServName]
	  ,[VolumeMP]
      ,[VolumeTotalMB]
      ,[VolumeAvailableMB]
      ,[MeasureDate]
      ,[is_current]
  FROM [Inventory].[dbo].[SrvVolumes] SV
  JOIN dbo.Servers s on SV.SrvId = s.ServID
  WHERE is_current = 1