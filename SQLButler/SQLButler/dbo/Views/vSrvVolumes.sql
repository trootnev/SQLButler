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
      ,IsCurrent
  FROM [dbo].[SrvVolumes] (nolock) SV
  JOIN dbo.Servers (nolock) s on SV.SrvId = s.ServID
  WHERE IsCurrent = 1