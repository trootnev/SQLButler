CREATE TABLE [dbo].[DbGroup] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [GroupName] NVARCHAR (150) NOT NULL,
    [GroupDesc] NVARCHAR (500) NULL,
    CONSTRAINT [PK_DbGroup] PRIMARY KEY CLUSTERED ([id] ASC)
);

