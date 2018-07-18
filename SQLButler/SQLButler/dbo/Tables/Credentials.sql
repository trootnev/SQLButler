CREATE TABLE [dbo].[Credentials] (
    [CrId]     INT           IDENTITY (1, 1) NOT NULL,
    [Login]    NVARCHAR (50) NOT NULL,
    [Password] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Credentials] PRIMARY KEY CLUSTERED ([CrId] ASC)
);

