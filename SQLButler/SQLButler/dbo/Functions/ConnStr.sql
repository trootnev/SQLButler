CREATE FUNCTION [dbo].[ConnStr]
(@servname NVARCHAR (50) NULL)
RETURNS NVARCHAR (100)
AS
BEGIN
    DECLARE @RESULT AS NVARCHAR (100);
    DECLARE @LOGIN AS NVARCHAR (50);
    DECLARE @PASSWORD AS NVARCHAR (50);
    IF EXISTS (SELECT 1
               FROM   dbo.Servers
               WHERE  ServName = @servname
                      AND CredID IS NOT NULL)
        SELECT @RESULT = 'Server=' + @servname + ';uid=' + c.login + ';PWD=' + c.Password + ';'
        FROM   dbo.Credentials AS C
               INNER JOIN
               dbo.servers AS s
               ON c.CrId = s.CredId
        WHERE  s.ServName = @servname;
    ELSE
        SELECT @RESULT = 'Server=' + @servname + ';Trusted_Connection=yes;';
    RETURN (@RESULT);
END

