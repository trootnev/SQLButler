CREATE TABLE [dbo].[SrvGroup] (
    [sgid]         INT           IDENTITY (1, 1) NOT NULL,
    [GroupName]    NVARCHAR (50) NOT NULL,
    [GroupComment] NTEXT         NULL,
    CONSTRAINT [PK_SrvGroup] PRIMARY KEY CLUSTERED ([sgid] ASC)
);

