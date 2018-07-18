CREATE TABLE [dbo].[LoginTypes] (
    [LoginTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [LoginTypeName] NVARCHAR (20)  NOT NULL,
    [LoginTypeDesc] NVARCHAR (255) NULL,
    CONSTRAINT [PK_dbo.LoginTypes] PRIMARY KEY CLUSTERED ([LoginTypeID] ASC)
);

