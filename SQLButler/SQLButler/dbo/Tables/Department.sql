CREATE TABLE [dbo].[Department] (
    [DepID]        INT            IDENTITY (1, 1) NOT NULL,
    [DepName]      NVARCHAR (255) NOT NULL,
    [DepCompanyID] INT            NULL,
    [DepManagerID] INT            NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED ([DepID] ASC),
    CONSTRAINT [FK_Department_Contacts] FOREIGN KEY ([DepManagerID]) REFERENCES [dbo].[Contacts] ([ContactID]),
    CONSTRAINT [FK_Department_Vendors] FOREIGN KEY ([DepCompanyID]) REFERENCES [dbo].[Vendors] ([VendorID])
);

