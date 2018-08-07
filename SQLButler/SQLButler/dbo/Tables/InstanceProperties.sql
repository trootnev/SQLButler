CREATE TABLE [dbo].[InstanceProperties] (
    [PropertyID]           UNIQUEIDENTIFIER CONSTRAINT [DF_InstanceProperties_PropertyID] DEFAULT (newsequentialid()) NOT NULL,
    [SrvID]                INT              NOT NULL,
    [PropertyTypeID]       INT              NOT NULL,
    [PropertyStringValue]  NVARCHAR (255)   NULL,
    [PropertyIntValue]     INT              NULL,
    [PropertyNumericValue] NUMERIC (18, 5)  NULL,
    [PropertyDate]         DATETIME         CONSTRAINT [DF_InstanceProperties_PropertyDate] DEFAULT (getdate()) NULL,
    [IsCurrent]            BIT              CONSTRAINT [DF_InstanceProperties_IsCurrent] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_InstanceProperties] PRIMARY KEY CLUSTERED ([PropertyID] ASC),
    CONSTRAINT [FK_InstanceProperties_InstancePropertyTypes] FOREIGN KEY ([PropertyTypeID]) REFERENCES [dbo].[InstancePropertyTypes] ([PropertyTypeID]),
    CONSTRAINT [FK_InstanceProperties_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID])
);

