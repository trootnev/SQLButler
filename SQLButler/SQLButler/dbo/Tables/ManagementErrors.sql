CREATE TABLE [dbo].[ManagementErrors] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [ActionDate]   DATETIME       NULL,
    [ActionType]   INT            NULL,
    [ActionObject] INT            NULL,
    [ErrorCode]    INT            NULL,
    [ErrorDesc]    NVARCHAR (250) NULL,
    CONSTRAINT [PK_ManagementErrors] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ManagementErrors_ActionTypes] FOREIGN KEY ([ActionType]) REFERENCES [dbo].[ActionTypes] ([TypeID])
);

