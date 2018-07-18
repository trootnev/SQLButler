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
FROM   [dbo].[ManagedLogins] AS ML
       LEFT OUTER JOIN
       dbo.Servers AS S
       ON ML.SrvID = S.ServID
       LEFT OUTER JOIN
       dbo.Contacts AS C
       ON ML.LoginOwnerID = C.ContactID;

