CREATE VIEW [dbo].[vManagementErrors]
AS
SELECT me.ActionDate AS ActionDate,
       at.TypeDesc AS ActionType,
       s.ServName AS ServerName,
       me.ErrorCode AS ErrorCode,
       me.ErrorDesc AS ErrorDescription
FROM   dbo.ManagementErrors AS me
       INNER JOIN
       dbo.ActionTypes AS at
       ON me.ActionType = at.TypeID
       INNER JOIN
       dbo.Servers AS s
       ON me.ActionObject = s.ServID
WHERE  (s.GetDBState <> 1)
       OR (s.GetVersState <> 1)
       OR (s.GetDbFilesState <> 1)
       OR (s.GetJobsState <> 1)
       OR (s.GetJobsDetailsState <> 1);

