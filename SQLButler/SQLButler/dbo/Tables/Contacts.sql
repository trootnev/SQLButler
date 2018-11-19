CREATE TABLE [dbo].[Contacts] (
    [ContactID]        INT            IDENTITY (1, 1) NOT NULL,
    [ContactAlias]     NVARCHAR (50)  NULL,
    [ContactFullName]  NVARCHAR (255) NOT NULL,
    [ContactShortName] NVARCHAR (100) NOT NULL,
    [ContactCompanyID] INT            NULL,
    [ContactDepID]     INT            NULL,
    [ContactRole]      NVARCHAR (255) NULL,
    [ContactPhone]     NVARCHAR (20)  NULL,
    [ContactEmail]     NVARCHAR (30)  NULL,
    [IsFTE]            BIT            CONSTRAINT [DF_Contacts_IsFTE] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED ([ContactID] ASC),
    CONSTRAINT [FK_Contacts_Vendors] FOREIGN KEY ([ContactCompanyID]) REFERENCES [dbo].[Vendors] ([VendorID])
);

