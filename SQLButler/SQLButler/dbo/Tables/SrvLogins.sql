CREATE TABLE [dbo].[SrvLogins] (
    [BatchId]        UNIQUEIDENTIFIER CONSTRAINT [SrvLogins_ID] DEFAULT (newid()) NOT NULL,
    [CollectionDate] DATETIME         CONSTRAINT [SrvLogins_ID_CollectionDate] DEFAULT (getdate()) NOT NULL,
    [srvid]          INT              NULL,
    [sid]            VARBINARY (256)  NULL,
    [LoginName]      NVARCHAR (50)    NULL,
    [Pass]           NVARCHAR (50)    NULL,
    [Comment]        NVARCHAR (150)   NULL,
    [Owner]          NVARCHAR (150)   NULL,
    [is_current]     BIT              DEFAULT ((1)) NOT NULL
);




GO

CREATE CLUSTERED INDEX [CLIX_SrvLogins_CollectionDate] ON [dbo].[SrvLogins] (CollectionDate)
