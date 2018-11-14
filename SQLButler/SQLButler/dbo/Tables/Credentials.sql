CREATE TABLE [dbo].[Credentials] (
    [CrId]     INT           IDENTITY (1, 1) NOT NULL,
    [CredName] NVARCHAR(255) NOT NULL DEFAULT 'NONAME',
	[Login]    NVARCHAR (50) NOT NULL,
    [Password] NVARCHAR (50) NOT NULL,
    [Description] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_Credentials] PRIMARY KEY CLUSTERED ([CrId] ASC)
);

