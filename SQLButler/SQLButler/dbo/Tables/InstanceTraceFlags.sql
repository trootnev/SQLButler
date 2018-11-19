CREATE TABLE [dbo].[InstanceTraceFlags] (
    [RecID]     UNIQUEIDENTIFIER CONSTRAINT [DF_InstanceTraceFlags_RecID] DEFAULT (newsequentialid()) NOT NULL,
    [Timestamp] DATETIME         CONSTRAINT [DF_InstanceTraceFlags_Timestamp] DEFAULT (getdate()) NOT NULL,
    [BatchID]   UNIQUEIDENTIFIER NOT NULL,
    [SrvID]     INT              NULL,
    [TraceFlag] SMALLINT         NOT NULL,
    [IsCurrent] BIT              CONSTRAINT [DF_InstanceTraceFlags_is_current] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_InstanceTraceFlags] PRIMARY KEY CLUSTERED ([RecID] ASC)
);

