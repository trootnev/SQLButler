CREATE PROCEDURE [dbo].[CollectSrvSQLAdmins]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 10;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT connstr
                    FROM   Servers AS s
                    WHERE  s.ServID = @SRVID);
    UPDATE Compliance_SrvSysadmins
    SET    is_current = 0
    WHERE  SrvID = @SrvID;
    SET @SQLStr = '
DECLARE @BatchID uniqueidentifier = (SELECT NEWID())

INSERT INTO [dbo].[Compliance_SrvSysadmins]
           (
           [BatchID]
           ,[SrvID]
          ,sa_name
		  ,is_current
		  )

SELECT
 @BatchID
	 ,' + CAST (@SRVID AS NVARCHAR (50)) + '
	 ,name
	 ,-1
FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
select  
		sp.name	
		from sys.server_role_members rm
JOIN sys.server_principals sp on rm.member_principal_id = sp.principal_id
join sys.syslogins sl on sp.sid = sl.sid
where rm.role_principal_id = 3
''' + ')
';
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        PRINT @ERROR_MESS;
        PRINT @sqlStr;
        EXECUTE dbo.WriteErrorLog 9, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
    DECLARE @D AS INT;
    SELECT @D = IntValue
    FROM   dbo.Settings
    WHERE  [name] = 'ConfRetentionDays';
    DELETE dbo.Compliance_SrvSysadmins
    WHERE  SrvID = @SRVID
           AND CollectionDate < DATEADD(DD, -@D, GETDATE());
END

