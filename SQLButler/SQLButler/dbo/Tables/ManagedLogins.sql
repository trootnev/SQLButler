CREATE TABLE [dbo].[ManagedLogins] (
    [LoginID]      UNIQUEIDENTIFIER CONSTRAINT [DF_ManagedLogins_LoginID] DEFAULT (newsequentialid()) NOT NULL,
    [SrvID]        INT              NOT NULL,
    [LoginName]    NVARCHAR (50)    NOT NULL,
    [Secret]       NVARCHAR (500)   NOT NULL,
    [LoginType]    INT              NOT NULL,
    [LoginPurpose] NVARCHAR (MAX)   NULL,
    [OrderID]      UNIQUEIDENTIFIER NULL,
    [LoginOwnerID] INT              NULL,
    [ValidFrom]    DATETIME         NULL,
    [ValidTill]    DATETIME         NULL,
    [timestamp]    ROWVERSION       NULL,
    CONSTRAINT [PK_ManagedLogins] PRIMARY KEY CLUSTERED ([LoginID] ASC),
    CONSTRAINT [FK_ManagedLogins_Contacts] FOREIGN KEY ([LoginOwnerID]) REFERENCES [dbo].[Contacts] ([ContactID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ManagedLogins]
    ON [dbo].[ManagedLogins]([SrvID] ASC) WITH (FILLFACTOR = 75);

