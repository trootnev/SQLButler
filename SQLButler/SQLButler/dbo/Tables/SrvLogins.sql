CREATE TABLE [dbo].[SrvLogins] (
    [BatchId]        UNIQUEIDENTIFIER CONSTRAINT [SrvLogins_ID] DEFAULT (newid()) NOT NULL,
    [CollectionDate] DATETIME         CONSTRAINT [SrvLogins_ID_CollectionDate] DEFAULT (getdate()) NOT NULL,
    [SrvId]          INT              NULL,
    [SID]            VARBINARY (256)  NULL,
    [LoginName]      NVARCHAR (50)    NULL,
    [Comment]        NVARCHAR (150)   NULL,
    [OwnerId]          INT   NULL,
    [IsCurrent]     BIT              DEFAULT ((1)) NOT NULL
);




GO

CREATE CLUSTERED INDEX [CLIX_SrvLogins_CollectionDate] ON [dbo].[SrvLogins] (CollectionDate)
