CREATE TABLE [dbo].[Bugs] (
    [Код]         INT            IDENTITY (1, 1) NOT NULL,
    [BugDesc]     NVARCHAR (255) NULL,
    [BugSeverity] NVARCHAR (255) NULL,
    [BugAction]   NVARCHAR (255) NULL,
    [BugStatus]   NVARCHAR (255) NULL,
    [BugDate]     DATETIME       NULL
);

