CREATE TABLE [dbo].[InstanceConfiguration] (
    [RecID]            UNIQUEIDENTIFIER CONSTRAINT [DF_InstanceConfiguration_RecID] DEFAULT (newsequentialid()) NOT NULL,
    [CollectionDate]        DATETIME         CONSTRAINT [DF_InstanceConfiguration_Timestamp] DEFAULT (getdate()) NOT NULL,
    [BatchID]          UNIQUEIDENTIFIER NOT NULL,
    [SrvID]            INT              NULL,
    [ConfigurationID] INT              NOT NULL,
    [ConfigurationName]             NVARCHAR (35)    NOT NULL,
    [ConfigurationValue]            SQL_VARIANT      NULL,
    [ConfigurationMinimum]          SQL_VARIANT      NULL,
    [ConfigurationMaximum]          SQL_VARIANT      NULL,
    [ConfigurationValueInUse]     SQL_VARIANT      NULL,
    [ConfigurationDescription]      NVARCHAR (255)   NOT NULL,
    [IsDynamic]       BIT              NOT NULL,
    [IsAdvanced]      BIT              NOT NULL,
    [IsCurrent]       BIT              CONSTRAINT [DF_InstanceConfiguration_is_current] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_InstanceConfiguration] PRIMARY KEY CLUSTERED ([RecID] ASC) WITH (FILLFACTOR = 80, PAD_INDEX = ON, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_InstanceConfiguration_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);




GO
CREATE NONCLUSTERED INDEX [NCIX_InstanceConfiguration_Covering]
    ON [dbo].[InstanceConfiguration]([SrvID] ASC, [ConfigurationName] ASC, [CollectionDate] DESC, [ConfigurationValue] ASC, [ConfigurationValueInUse] ASC) WITH (FILLFACTOR = 80, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [NCIX_InstanceConfiguration_SrvID]
    ON [dbo].[InstanceConfiguration]([SrvID] ASC) WITH (FILLFACTOR = 75, PAD_INDEX = ON);

