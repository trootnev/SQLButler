CREATE TABLE [dbo].[Compliance_SrvSysadmins] (
    [RecId]          UNIQUEIDENTIFIER CONSTRAINT [DF_Compliance_SrvSysadmins_RecId] DEFAULT (newsequentialid()) NOT NULL,
    [BatchID]        UNIQUEIDENTIFIER CONSTRAINT [DF_Compliance_SrvSysadmins_BatchID] DEFAULT (newid()) NOT NULL,
    [CollectionDate] DATETIME         CONSTRAINT [DF_Compliance_SrvSysadmins_CollectionDate] DEFAULT (getdate()) NOT NULL,
    [SrvID]          INT              NOT NULL,
    [sa_name]        NVARCHAR (50)    NOT NULL,
    [Is_current]     BIT              NOT NULL,
    CONSTRAINT [PK_Compliance_SrvSysadmins] PRIMARY KEY CLUSTERED ([RecId] ASC)
);

