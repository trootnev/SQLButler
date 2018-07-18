CREATE VIEW [dbo].[vContacts]
WITH SCHEMABINDING
AS
SELECT c.ContactID,
       c.ContactAlias,
       c.ContactFullName,
       c.ContactShortName,
       c.ContactRole,
       d.DepName,
       v.VendorName,
       c.ContactPhone,
       c.ContactEmail,
       c.IsFTE,
       c.ContactCompanyID,
       c.ContactDepID
FROM   dbo.Contacts AS c
       LEFT OUTER JOIN
       dbo.Department AS d
       ON c.ContactDepID = d.DepID
       LEFT OUTER JOIN
       dbo.Vendors AS v
       ON c.ContactCompanyID = v.VendorID;


GO
CREATE TRIGGER [dbo].[vContacts_Delete]
    ON [dbo].[vContacts]
    INSTEAD OF DELETE
    AS BEGIN
           DELETE dbo.Contacts
           WHERE  ContactID = (SELECT ContactID
                               FROM   deleted);
       END

