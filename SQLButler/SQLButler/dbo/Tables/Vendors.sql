CREATE TABLE [dbo].[Vendors] (
    [VendorID]         INT           IDENTITY (1, 1) NOT NULL,
    [VendorName]       NVARCHAR (50) NULL,
    [ContractNumber]   NVARCHAR (50) NULL,
    [PrimaryContactID] INT           NULL,
    [IsActive]         BIT           NULL,
    CONSTRAINT [PK_Vendors] PRIMARY KEY CLUSTERED ([VendorID] ASC)
);

