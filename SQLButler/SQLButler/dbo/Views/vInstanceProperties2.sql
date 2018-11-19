CREATE VIEW dbo.vInstanceProperties2
as
SELECT 
	SrvId
	,ServName
	,[LocalTcpPort]
	,[SQLServerSvcAccount]
	,[SQLServerAgentSvcAccount]
	,[InstanceCollation]
	,[IsHADREnabled]
	,[isClustered]
	,[CpuCount]
	,[HyperthreadRatio]
	,[MaxWorkers]
	,[SystemModel]
FROM(

SELECT SrvId, ServName, PropertyTypeName,PropertyStringValue FROM dbo.vInstanceProperties) as Source
PIVOT
(
MAX(PropertyStringValue)
FOR PropertyTypeName in ([LocalTcpPort],[SQLServerSvcAccount],[SQLServerAgentSvcAccount],[InstanceCollation],[IsHADREnabled],[isClustered],[CpuCount],[HyperthreadRatio],[MaxWorkers],[SystemModel])
) as PivotTable