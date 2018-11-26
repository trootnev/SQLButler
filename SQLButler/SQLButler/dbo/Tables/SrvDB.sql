CREATE TABLE [dbo].[SrvDB] (
    [DbID]           INT            IDENTITY (1, 1) NOT NULL,
    [SrvID]          INT            NOT NULL,
    [DbName]         NVARCHAR (50)  NULL,
    [DbComment]      NVARCHAR(MAX)          NULL,
    [DbGroup]        INT            NULL,
    [DBSize]         AS             ([dbo].[CalcDBSize]([DbID])),
    [BackupNeeded]   BIT            CONSTRAINT [DF_SrvDB_BackupNeeded] DEFAULT ((0)) NULL,
    [BackupMod]      INT            NULL,
    [RecMod]         INT            NULL,
    [BcpPath]        NVARCHAR(MAX)          NULL,
    [Order4Create]   NVARCHAR (50)  NULL,
    [OrderDate]      DATE           NULL,
    [SizeOrdered_GB] FLOAT (53)     NULL,
    [ImpLevel]       INT            NULL,
    [Customer]       NVARCHAR (MAX) NULL,
    [SLA]            INT            NULL,
    [Malfunction]    NVARCHAR(MAX)          NULL,
    [OwnerLogin] NVARCHAR(100) NULL, 
    CONSTRAINT [PK_SrvDB] PRIMARY KEY CLUSTERED ([DbID] ASC),
    CONSTRAINT [FK_SrvDB_DbGroup] FOREIGN KEY ([DbGroup]) REFERENCES [dbo].[DbGroup] ([id]) ON DELETE SET NULL,
    CONSTRAINT [FK_SrvDB_RecModel] FOREIGN KEY ([RecMod]) REFERENCES [dbo].[RecModel] ([id]),
    CONSTRAINT [FK_SrvDB_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);



