
CREATE VIEW dbo.vServers2
as
Select CASE GetVersState WHEN 1 THEN 'Ok' ELSE GetVersStateDesc END as Connection_Status
,s.IsActive 
,h.HostName
,s.ServName
,ISNULL(s.IsHADREnabled, 0) IsHADREnabled
,ip.PropertyStringValue as DBEngineVersion
,CASE WHEN ip.PropertyStringValue like '9.00%' THEN '2005' 
	  WHEN ip.PropertyStringValue like '10.0%' THEN '2008' 
	  WHEN ip.PropertyStringValue like '10.50%' THEN '2008 R2'
	  WHEN ip.PropertyStringValue like '11.%' THEN '2012' 
	  WHEN ip.PropertyStringValue like '12%' THEN '2014'
	  WHEN ip.PropertyStringValue like '13%' THEN '2016'
	  WHEN ip.PropertyStringValue like '14%' THEN '2017'
	  WHEN ip.PropertyStringValue like '15%' THEN '2019'
	  ELSE 'OTHER' END as VersionDescription
,ip2.PropertyStringValue as DBEngineProductLevel
,ip3.PropertyStringValue as DBEngineEdition
,CASE WHEN ip4.PropertyStringValue like '%VMWare%' or ip4.PropertyStringValue like '%Hyper%' THEN 'Virtual'
ELSE 'Physical' end AS Hardware 
,s.SrvComment as InstanceDescription

FROM dbo.Servers s
JOIN dbo.Hosts h on s.HostID = h.HostID
LEFT OUTER JOIN dbo.vInstanceProperties ip on s.ServID = ip.SrvID and ip.PropertyTypeName = 'DBEngineVersion'
LEFT OUTER JOIN dbo.vInstanceProperties ip2 on s.ServID = ip2.SrvID and ip2.PropertyTypeName = 'DBEngineProductLevel' 
LEFT OUTER JOIN dbo.vInstanceProperties ip3 on s.ServID = ip3.SrvID and ip3.PropertyTypeName = 'DBEngineEdition'
LEFT OUTER JOIN dbo.vInstanceProperties ip4 on s.ServID = ip4.SrvID and ip4.PropertyTypeName = 'SystemModel'