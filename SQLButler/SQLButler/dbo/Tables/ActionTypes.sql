CREATE TABLE [dbo].[ActionTypes] (
    [TypeID]   INT            NOT NULL,
    [TypeDesc] NVARCHAR (150) NULL,
    CONSTRAINT [PK_ActionTypes] PRIMARY KEY CLUSTERED ([TypeID] ASC)
);

