CREATE TABLE [dbo].[SrvLogins] (
   [RecId]	UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (NEWSEQUENTIALID()),
   [BatchID]        UNIQUEIDENTIFIER CONSTRAINT [SrvLogins_ID] DEFAULT (newid()) NOT NULL,
    [CollectionDate] DATETIME         CONSTRAINT [SrvLogins_ID_CollectionDate] DEFAULT (getdate()) NOT NULL,
    [SrvID]          INT              NULL,
    [SID]            VARBINARY (256)  NULL,
    [LoginName]      NVARCHAR (50)    NULL,
    [Comment]        NVARCHAR (150)   NULL,
    [OwnerID]          INT   NULL,
    [IsCurrent]     BIT              DEFAULT ((1)) NOT NULL
);




GO

CREATE NONCLUSTERED INDEX [IX_SrvLogins_CollectionDate] ON [dbo].[SrvLogins] (IsCurrent,CollectionDate)
