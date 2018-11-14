CREATE TABLE [dbo].[SrvGroup] (
    [sgid]         INT           IDENTITY (1, 1) NOT NULL,
    [GroupName]    NVARCHAR (50) NOT NULL,
    [GroupComment] NVARCHAR(MAX)         NULL,
    CONSTRAINT [PK_SrvGroup] PRIMARY KEY CLUSTERED ([sgid] ASC)
);

