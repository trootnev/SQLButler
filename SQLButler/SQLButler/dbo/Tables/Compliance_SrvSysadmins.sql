﻿CREATE TABLE [dbo].[Compliance_SrvSysadmins] (
    [RecID]          UNIQUEIDENTIFIER CONSTRAINT [DF_Compliance_SrvSysadmins_RecID] DEFAULT (newsequentialid()) NOT NULL,
    [BatchID]        UNIQUEIDENTIFIER CONSTRAINT [DF_Compliance_SrvSysadmins_BatchID] DEFAULT (newid()) NOT NULL,
    [CollectionDate] DATETIME         CONSTRAINT [DF_Compliance_SrvSysadmins_CollectionDate] DEFAULT (getdate()) NOT NULL,
    [SrvID]          INT              NOT NULL,
    [SAName]        NVARCHAR (50)    NOT NULL,
    [IsCurrent]     BIT              NOT NULL,
    CONSTRAINT [PK_Compliance_SrvSysadmins] PRIMARY KEY CLUSTERED ([RecID] ASC)
);

