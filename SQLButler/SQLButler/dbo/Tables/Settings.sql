CREATE TABLE [dbo].[Settings] (
    [SettingID]   INT             IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)   NOT NULL,
    [IntValue]    INT             NULL,
    [StringValue] NVARCHAR (255)  NULL,
    [Description] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_dbo.Settings] PRIMARY KEY CLUSTERED ([SettingID] ASC)
);

