CREATE TABLE [dbo].[SrvDB] (
    [DbID]           INT            IDENTITY (1, 1) NOT NULL,
    [SrvID]          INT            NOT NULL,
    [DbName]         NVARCHAR (50)  NULL,
    [DbComment]      NTEXT          NULL,
    [DbGroupID]        INT            NULL,
    [DBSize]         AS             ([dbo].[CalcDBSize]([DbID])),
    [BackupNeeded]   BIT            CONSTRAINT [DF_SrvDB_BackupNeeded] DEFAULT ((0)) NULL,
    [BackupMod]      INT            NULL,
    [RecMod]         INT            NULL,
    [BcpPath]        NVARCHAR(MAX)          NULL,
    [CMID]   NVARCHAR (50)  NULL,
    [CMDate]      DATE           NULL,
    [PlanedSizeGB] DECIMAL(18, 3)     NULL,
    [Impact]       INT            NULL,
    [CustomerDepartmentID]       INT NULL,
    [SLA]            INT            NULL,
    [Malfunction]    NVARCHAR(MAX)          NULL,
    [OwnerLogin] NVARCHAR(100) NULL, 
    CONSTRAINT [PK_SrvDB] PRIMARY KEY CLUSTERED ([DbID] ASC),
    CONSTRAINT [FK_SrvDB_DbGroup] FOREIGN KEY ([DbGroupID]) REFERENCES [dbo].[DbGroup] ([id]) ON DELETE SET NULL,
    CONSTRAINT [FK_SrvDB_RecModel] FOREIGN KEY ([RecMod]) REFERENCES [dbo].[RecModel] ([id]),
    CONSTRAINT [FK_SrvDB_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE,
	CONSTRAINT [FK_SrvDB_Contacts] FOREIGN KEY ([CustomerDepartmentID]) REFERENCES [dbo].[Department] (DepID)
);



