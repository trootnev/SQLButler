CREATE FUNCTION [dbo].[ConnStr]
(@servname NVARCHAR (50) = NULL)
RETURNS NVARCHAR (100)
AS
BEGIN
RETURN(SELECT 
CASE
	WHEN s.CredID is NULL THEN 'Server=' + @servname + ';Trusted_Connection=yes;' + ISNULL('Timeout='+ CAST(ConnectionTimeout as nvarchar(10)) + ';', '')
	WHEN  s.CredID IS NOT NULL THEN 'Server=' + @servname + ';uid=' + c.Login + ';PWD=' + c.Password + ';'+ ISNULL('Timeout='+ CAST(ConnectionTimeout as nvarchar(10)) + ';', '')
	END as ConnStr
FROM 
dbo.Servers s
LEFT JOIN dbo.Credentials c
on c.CrId = s.CredID
WHERE
 s.ServName = @servname
 and s.IsActive = 1)

END

