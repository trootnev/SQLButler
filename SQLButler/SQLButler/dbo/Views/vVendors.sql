CREATE VIEW [dbo].[vVendors]
AS
SELECT dbo.Vendors.VendorID,
       dbo.Vendors.VendorName,
       dbo.Vendors.ContractNumber,
       dbo.Vendors.PrimaryContactID,
       dbo.Contacts.ContactShortName AS PrimaryContactDesc,
       dbo.Vendors.IsActive
FROM   dbo.Vendors
       LEFT OUTER JOIN
       dbo.Contacts
       ON dbo.Vendors.VendorID = dbo.Contacts.ContactCompanyID
          AND dbo.Vendors.PrimaryContactID = dbo.Contacts.ContactID;

