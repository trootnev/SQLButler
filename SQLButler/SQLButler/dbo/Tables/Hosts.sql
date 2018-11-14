CREATE TABLE [dbo].[Hosts] (
    [HostID]   INT            IDENTITY (1, 1) NOT NULL,
    [HostName] NVARCHAR (150) NOT NULL,
    [HostIP]   NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Hosts] PRIMARY KEY CLUSTERED ([HostID] ASC),
    CONSTRAINT [IX_Hosts] UNIQUE NONCLUSTERED ([HostName] ASC)
);

