CREATE VIEW dbo.[vServersDetailed]
AS

SELECT dbo.Servers.IsHADREnabled, 
dbo.Servers.IsClustered, 
dbo.Servers.ClusterID, 
dbo.Cluster.ClusterName, 
dbo.Hosts.Hostname, 
dbo.Servers.HostID,
 dbo.Servers.ServID, 
 dbo.Servers.ServName, 
 dbo.Servers.ServGroup, 
 dbo.Servers.CredID, 
 dbo.vCredentials.Login, 
 dbo.Servers.Version,
  dbo.Servers.IsActive,
   dbo.Servers.SrvComment, 
   dbo.Contacts.ContactShortName, 
   dbo.Servers.OwnerID
   
   FROM (((dbo.Servers (NOLOCK) LEFT JOIN dbo.Hosts (NOLOCK) ON dbo.Servers.HostID = dbo.Hosts.HostID) LEFT JOIN dbo.Cluster (NOLOCK) ON dbo.Servers.ClusterID = dbo.Cluster.Clusterid) LEFT JOIN dbo.vCredentials ON dbo.Servers.CredID = dbo.vCredentials.CrId) INNER JOIN dbo.Contacts (NOLOCK) ON dbo.Servers.OwnerID = dbo.Contacts.ContactID
--WHERE (((dbo.Servers.ServID)=[TEMPVARS]![SRVID]));