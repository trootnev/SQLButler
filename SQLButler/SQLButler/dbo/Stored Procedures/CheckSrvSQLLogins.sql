CREATE PROCEDURE [dbo].[CheckSrvSQLLogins]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 8;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers
                    WHERE  ServID = @SRVID);
    UPDATE dbo.Compliance_SQLLogins
    SET    IsCurrent = 0
    WHERE  SrvID = @SrvID;
    SET @SQLStr = '
DECLARE @BatchID uniqueidentifier = (SELECT NEWID())

INSERT INTO [dbo].[Compliance_SQLLogins]
           (
           [BatchID]
           ,[SrvID]
          ,[Login]
           ,[same_as_login]
           ,[blank]
           ,[123]
           ,[1234]
           ,[12345]
           ,[Password]
           ,[P@ssword]
           ,[P@ssw0rd]
           ,[IsCurrent])

SELECT
 @BatchID
	 ,' + CAST (@SRVID AS NVARCHAR (50)) + '
	 ,name
	 ,[same_as_login]
           ,[blank]
           ,[123]
           ,[1234]
           ,[12345]
           ,[Password]
           ,[P@ssword]
           ,[P@ssw0rd]
	 
	 ,-1
FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''
select  
sp.name,
		PWDCOMPARE(sp.name,password) same_as_login,
		PWDCOMPARE('''''''',password) as [blank],
		PWDCOMPARE(''''123'''',password) as [123],
		PWDCOMPARE(''''1234'''',password) as [1234],
		PWDCOMPARE(''''12345'''',password) as [12345],
		PWDCOMPARE(''''Password'''',password) as [Password],
		PWDCOMPARE(''''P@ssword'''',password) as [P@ssword],
		PWDCOMPARE(''''P@ssw0rd'''',password) as [P@ssw0rd]
		
		from sys.server_role_members rm
JOIN sys.server_principals sp on rm.member_principal_id = sp.principal_id
join sys.syslogins sl on sp.sid = sl.sid
where sp.type_desc = ''''SQL_LOGIN''''
	  and 
	    PWDCOMPARE(sp.name,password) + PWDCOMPARE('''''''',password) +		PWDCOMPARE(''''123'''',password) +
		PWDCOMPARE(''''1234'''',password) +
		PWDCOMPARE(''''12345'''',password) +
		PWDCOMPARE(''''Password'''',password)+
		PWDCOMPARE(''''P@ssword'''',password)+
		PWDCOMPARE(''''P@ssw0rd'''',password) > 0
''' + ')
';
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        EXECUTE dbo.WriteErrorLog 8, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
    DECLARE @D AS INT;
    SELECT @D = IntValue
    FROM   dbo.Settings
    WHERE  [name] = 'ConfRetentionDays';
    DELETE dbo.Compliance_SQLLogins
    WHERE  SrvID = @SRVID
           AND CollectionDate < DATEADD(DD, -@D, GETDATE());
END

