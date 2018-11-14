CREATE TABLE [dbo].[DbFiles] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [DbId]             INT            NOT NULL,
    [InternalFileId]      INT            NOT NULL,
    [FileType]              INT            NOT NULL,
    [FileSize]              INT            NOT NULL,
    [FileMaxSize]           INT            NOT NULL,
    [FileGrowth]            INT            NOT NULL,
    [FileLogicalName]              [sysname]      NOT NULL,
    [FileName]          NVARCHAR (255) NOT NULL,
    [MeasureDate]       DATETIME       NULL,
    [VolumeMountpoint]             AS             (left([FileName],(2))) PERSISTED,
    [IsPercentGrowth] BIT            CONSTRAINT [DF_DbFiles_is_percent_growth] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_DbFiles] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_DbFiles_SrvDB] FOREIGN KEY ([DbId]) REFERENCES [dbo].[SrvDB] ([DbID]) ON DELETE CASCADE
);




GO
CREATE NONCLUSTERED INDEX [IX_DbFiles]
    ON [dbo].[DbFiles]([DbId] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_IndexName]
    ON [dbo].[DbFiles]([FileType] ASC)
    INCLUDE([DbId]);

