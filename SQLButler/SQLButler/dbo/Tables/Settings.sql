CREATE TABLE [dbo].[Settings] (
    [SettingID]   INT             IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)   NOT NULL,
    [IntValue]    INT             NOT NULL,
    [StringValue] NVARCHAR (255)  NOT NULL,
    [Description] NVARCHAR (4000) NOT NULL,
    CONSTRAINT [PK_dbo.Settings] PRIMARY KEY CLUSTERED ([SettingID] ASC)
);

