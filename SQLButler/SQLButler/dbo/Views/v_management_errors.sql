CREATE VIEW [dbo].[v_management_errors]
AS
SELECT me.ActionDate AS Дата,
       at.TypeDesc AS Действие,
       s.ServName AS Сервер,
       me.ErrorCode AS [Код Ошибки],
       me.ErrorDesc AS [Описание ошибки]
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

