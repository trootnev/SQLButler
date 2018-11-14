CREATE TABLE [dbo].[Compliance_SQLLogins] (
    [RecId]          UNIQUEIDENTIFIER CONSTRAINT [DF_Compliance_SQLLogins_RecId] DEFAULT (newsequentialid()) NOT NULL,
    [BatchId]        UNIQUEIDENTIFIER CONSTRAINT [DF_Compliance_SQLLogins_batch_id] DEFAULT (newid()) NOT NULL,
    [SrvId]          INT              NOT NULL,
    [CollectionDate] DATETIME         CONSTRAINT [DF_Compliance_SQLLogins_CollectionDate] DEFAULT (getdate()) NOT NULL,
    [Login]          [sysname]        NOT NULL,
    [same_as_login]  INT              NULL,
    [blank]          INT              NULL,
    [123]            INT              NULL,
    [1234]           INT              NULL,
    [12345]          INT              NULL,
    [Password]       INT              NULL,
    [P@ssword]       INT              NULL,
    [P@ssw0rd]       INT              NULL,
    [IsCurrent]     BIT              CONSTRAINT [DF_Compliance_SQLLogins_is_current] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Compliance_SQLLogins] PRIMARY KEY CLUSTERED ([RecId] ASC)
);

