CREATE TABLE [dbo].[Servers] (
    [ServID]                  INT            IDENTITY (1, 1) NOT NULL,
    [IsClustered]             BIT            CONSTRAINT [DF_Servers_IsClustered] DEFAULT ((0)) NULL,
    [IsHADREnabled]           BIT            NULL,
    [ClusterID]               INT            NULL,
    [HostID]                  INT            NULL,
    [ServName]                NVARCHAR (100) NOT NULL,
    [ServGroup]               INT            NULL,
    [Version]                 NVARCHAR (250) NULL,
    [CredID]                  INT            NULL,
    [connstr]                 AS             ([dbo].[ConnStr]([ServName])),
    [active]                  INT            CONSTRAINT [DF_Servers_is active] DEFAULT ((0)) NULL,
    [SrvComment]              NVARCHAR (MAX) NULL,
    [ip]                      NVARCHAR (20)  NULL,
    [OwnerID]                 INT            NOT NULL,
    [GetVersState]            INT            NULL,
    [GetVersStateDesc]        NVARCHAR (150) NULL,
    [GetDBState]              INT            NULL,
    [GetDBStateDesc]          NVARCHAR (150) NULL,
    [GetDbFilesState]         INT            NULL,
    [GetDbFilesStateDesc]     NVARCHAR (150) NULL,
    [GetJobsState]            INT            NULL,
    [GetJobsStateDesc]        NVARCHAR (150) NULL,
    [GetJobsDetailsState]     INT            NULL,
    [GetJobsDetailsStateDesc] NVARCHAR (150) NULL,
    [Timestamp]               ROWVERSION     NULL,
    CONSTRAINT [PK_Servers] PRIMARY KEY CLUSTERED ([ServID] ASC),
    CONSTRAINT [FK_Servers_Cluster] FOREIGN KEY ([ClusterID]) REFERENCES [dbo].[Cluster] ([Clusterid]),
    CONSTRAINT [FK_Servers_Contacts] FOREIGN KEY ([OwnerID]) REFERENCES [dbo].[Contacts] ([ContactID]),
    CONSTRAINT [FK_Servers_Credentials] FOREIGN KEY ([CredID]) REFERENCES [dbo].[Credentials] ([CrId]),
    CONSTRAINT [FK_Servers_Hosts] FOREIGN KEY ([HostID]) REFERENCES [dbo].[Hosts] ([HostID]),
    CONSTRAINT [FK_Servers_SrvGroup] FOREIGN KEY ([ServGroup]) REFERENCES [dbo].[SrvGroup] ([sgid])
);


GO
CREATE NONCLUSTERED INDEX [IX_Servers_ClusterID]
    ON [dbo].[Servers]([ClusterID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Servers_HostId]
    ON [dbo].[Servers]([HostID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Servers_OwnerID]
    ON [dbo].[Servers]([OwnerID] ASC) WITH (FILLFACTOR = 75);


GO
CREATE NONCLUSTERED INDEX [IX_Servers_ServGroup]
    ON [dbo].[Servers]([ServGroup] ASC);

