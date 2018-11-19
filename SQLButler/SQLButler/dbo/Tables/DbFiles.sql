CREATE TABLE [dbo].[DbFiles] (
    [id]                INT            IDENTITY (1, 1) NOT NULL,
    [db_id]             INT            NOT NULL,
    [inner_fileid]      INT            NOT NULL,
    [type]              INT            NOT NULL,
    [size]              INT            NOT NULL,
    [maxsize]           INT            NOT NULL,
    [growth]            INT            NOT NULL,
    [name]              [sysname]      NOT NULL,
    [filename]          NVARCHAR (255) NOT NULL,
    [MeasureDate]       DATETIME       NULL,
    [Drive]             AS             (left([filename],(2))) PERSISTED,
    [is_percent_growth] BIT            CONSTRAINT [DF_DbFiles_is_percent_growth] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_DbFiles] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_DbFiles_SrvDB] FOREIGN KEY ([db_id]) REFERENCES [dbo].[SrvDB] ([DbID]) ON DELETE CASCADE
);




GO
CREATE NONCLUSTERED INDEX [IX_DbFiles]
    ON [dbo].[DbFiles]([db_id] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_IndexName]
    ON [dbo].[DbFiles]([type] ASC)
    INCLUDE([db_id]);

