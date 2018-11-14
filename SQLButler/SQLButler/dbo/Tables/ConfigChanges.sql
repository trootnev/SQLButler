CREATE TABLE [dbo].[ConfigChanges] (
    [RecID]                INT           IDENTITY (1, 1) NOT NULL,
    [SrvID]                INT           NOT NULL,
    [Parameter]            NVARCHAR (35) NOT NULL,
    [DetectionTime] DATETIME      NOT NULL,
    [NewValue]            SQL_VARIANT   NULL,
    [ValueInUse]         SQL_VARIANT   NULL,
    [PrevTimestamp]       DATETIME      NOT NULL,
    [PrevValue]           SQL_VARIANT   NULL,
    [PrevValueInUse]    SQL_VARIANT   NULL,
    [Approved]             BIT           CONSTRAINT [DF_ConfigChanges_Approved] DEFAULT ((0)) NOT NULL,
    [timestamp]                   ROWVERSION    NULL,
    CONSTRAINT [PK_ConfigChanges] PRIMARY KEY CLUSTERED ([RecID] ASC),
    CONSTRAINT [FK_ConfigChanges_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);



