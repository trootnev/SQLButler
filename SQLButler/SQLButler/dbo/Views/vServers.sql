


CREATE VIEW [dbo].[vServers]
AS


SELECT s.ServID,
		s.HostID,
		h.HostName,

       s.ServName,
       s.SrvComment,
	   s.ServGroup as SrvGroupId,
       sg.GroupName as SrvGroupName,
      sg.GroupComment,
	  s.OwnerID,
       c.ContactShortName as OwnerName,
       s.Version,
       s.ServGroup,
      s.IsActive,
       s.GetVersState,
       s.GetVersStateDesc,
       s.GetDBState,
       s.GetDBStateDesc,
       s.GetDbFilesState,
       s.GetDbFilesStateDesc,
       s.GetJobsState,
      s.GetJobsStateDesc,
       s.GetJobsDetailsState,
       s.GetJobsDetailsStateDesc,
	   ip.PropertyDate as LastExaminedDate
	   FROM   dbo.Servers s (nolock)
	   JOIN dbo.Hosts h on h.HostID = s.HostID
       LEFT OUTER JOIN
       dbo.SrvGroup sg (nolock)
       ON s.ServGroup = sg.sgid
       LEFT OUTER JOIN
       dbo.Contacts (nolock) AS c
       ON s.OwnerID = c.ContactID
	   LEFT OUTER JOIN
	   dbo.InstanceProperties ip(nolock) 
	   ON ip.SrvID = s.ServID
	   INNER JOIN
	   dbo.InstancePropertyTypes ipt (nolock)
		ON ip.PropertyTypeID = ipt.PropertyTypeID
	WHERE  ip.PropertyTypeID = 1 and ip.IsCurrent = 1

