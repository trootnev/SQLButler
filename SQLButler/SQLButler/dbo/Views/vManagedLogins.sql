CREATE VIEW [dbo].[vManagedLogins]
AS
SELECT LoginID,
       SrvID,
       S.ServName AS ServerName,
       LoginName AS [Login],
       [Secret] AS [Password],
       LoginType,
       LoginPurpose,
       LoginOwnerID,
       C.ContactShortName,
       ValidFrom,
       ValidTill
FROM   [dbo].[ManagedLogins] (nolock) AS ML
       LEFT OUTER JOIN
       dbo.Servers (nolock) AS S
       ON ML.SrvID = S.ServID
       LEFT OUTER JOIN
       dbo.Contacts (nolock) AS C
       ON ML.LoginOwnerID = C.ContactID;

