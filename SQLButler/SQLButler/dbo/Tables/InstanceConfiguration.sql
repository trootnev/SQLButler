CREATE TABLE [dbo].[InstanceConfiguration] (
    [RecID]            UNIQUEIDENTIFIER CONSTRAINT [DF_InstanceConfiguration_RecID] DEFAULT (newsequentialid()) NOT NULL,
    [Timestamp]        DATETIME         CONSTRAINT [DF_InstanceConfiguration_Timestamp] DEFAULT (getdate()) NOT NULL,
    [BatchID]          UNIQUEIDENTIFIER NOT NULL,
    [SrvID]            INT              NULL,
    [configuration_id] INT              NOT NULL,
    [name]             NVARCHAR (35)    NOT NULL,
    [value]            SQL_VARIANT      NULL,
    [minimum]          SQL_VARIANT      NULL,
    [maximum]          SQL_VARIANT      NULL,
    [value_in_use]     SQL_VARIANT      NULL,
    [description]      NVARCHAR (255)   NOT NULL,
    [is_dynamic]       BIT              NOT NULL,
    [is_advanced]      BIT              NOT NULL,
    [is_current]       BIT              CONSTRAINT [DF_InstanceConfiguration_is_current] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_InstanceConfiguration] PRIMARY KEY CLUSTERED ([RecID] ASC) WITH (FILLFACTOR = 80, PAD_INDEX = ON, DATA_COMPRESSION = PAGE),
    CONSTRAINT [FK_InstanceConfiguration_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);




GO
CREATE NONCLUSTERED INDEX [NCIX_InstanceConfiguration_Covering]
    ON [dbo].[InstanceConfiguration]([SrvID] ASC, [name] ASC, [Timestamp] DESC, [value] ASC, [value_in_use] ASC) WITH (FILLFACTOR = 80, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [NCIX_InstanceConfiguration_SrvID]
    ON [dbo].[InstanceConfiguration]([SrvID] ASC) WITH (FILLFACTOR = 75, PAD_INDEX = ON);

