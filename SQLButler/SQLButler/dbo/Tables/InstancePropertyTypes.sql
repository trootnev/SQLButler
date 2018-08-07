CREATE TABLE [dbo].[InstancePropertyTypes] (
    [PropertyTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [PropertyTypeName] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_InstancePropertyTypes] PRIMARY KEY CLUSTERED ([PropertyTypeID] ASC)
);

