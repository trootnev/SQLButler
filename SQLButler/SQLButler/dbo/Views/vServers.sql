CREATE VIEW [dbo].[vServers]
AS
SELECT dbo.Servers.ServID,
       dbo.Servers.ServName,
       dbo.Servers.SrvComment,
       dbo.SrvGroup.GroupName,
       dbo.SrvGroup.GroupComment,
       c.ContactShortName,
       dbo.Servers.Version,
       dbo.Servers.ServGroup,
       dbo.Servers.IsActive,
       dbo.Servers.GetVersState,
       dbo.Servers.GetVersStateDesc,
       dbo.Servers.GetDBState,
       dbo.Servers.GetDBStateDesc,
       dbo.Servers.GetDbFilesState,
       dbo.Servers.GetDbFilesStateDesc,
       dbo.Servers.GetJobsState,
       dbo.Servers.GetJobsStateDesc,
       dbo.Servers.GetJobsDetailsState,
       dbo.Servers.GetJobsDetailsStateDesc
FROM   dbo.Servers (nolock)
       LEFT OUTER JOIN
       dbo.SrvGroup (nolock)
       ON dbo.Servers.ServGroup = dbo.SrvGroup.sgid
       LEFT OUTER JOIN
       dbo.Contacts (nolock) AS c
       ON dbo.Servers.OwnerID = c.ContactID;

