CREATE PROCEDURE [dbo].[CollectSrvPrincipals]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 9;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT connstr
                    FROM   Servers AS s
                    WHERE  s.ServID = @SRVID);
    SET @SQLStr = '
DECLARE @ID uniqueidentifier = (SELECT NEWID())

UPDATE dbo.SrvLogins
SET is_current = 0
where SrvID = '+CAST(@SRVID as nvarchar(10))+'
AND is_current = 1


INSERT INTO [dbo].[SrvLogins]
           (
           [BatchId]
           ,[srvid]
		   ,[sid]
		   ,[LoginName]
           ,[Pass]
		   ,[is_current]
		  )

SELECT
 @ID
	 ,' + CAST (@SRVID AS NVARCHAR (50)) + '
	,[sid]
	,[loginname]
	,[password]
	,1

FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
select  [sid]
	,[loginname]
	,[password]
from sys.syslogins
WHERE hasaccess=1
''' + ')


UPDATE dbo.SrvRoleMembers
SET is_current = 0
where SrvId =' + CAST (@SRVID AS NVARCHAR (50)) + '
AND is_current = 1

INSERT INTO [dbo].[SrvRoleMembers]
           (batch_id
		   ,SrvID
		   ,[CollectionDate]
           ,[RoleType]
           ,[Role]
           ,[Member]
           ,[Login]
           ,[SID]
		   ,[is_current])
     
SELECT @ID
		,' + CAST (@SRVID AS NVARCHAR (50)) + '
		,getdate()
		,[RoleType]
           ,[Role]
           ,[Member]
           ,[Login]
           ,[SID]
		   ,1

	FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
SET NOCOUNT ON
DECLARE @t table (RoleType nvarchar(255),
					[Role] nvarchar(255), 
					[Member] nvarchar(255),
					[Login] nvarchar(255), 
					[SID] varbinary(255))
INSERT @t 
EXEC sp_MSforeachdb ''''
USE [?]
select db_name() as [RoleType],dbp1.name as [Role],dbp2.name as [Member],sl.name as [Login], sl.sid as [SID] 
from msdb.sys.database_role_members dbrm
join msdb.sys.database_principals dbp1 on dbp1.principal_id = dbrm.role_principal_id and dbp1.type= ''''''''R''''''''
join msdb.sys.database_principals dbp2 on dbp2.principal_id = dbrm.member_principal_id
join msdb.sys.syslogins sl on sl.sid = dbp2.sid
''''
select [RoleType],
		[Role],
		[Member],
		[Login],
		[SID]
		,1
		 from @t 

UNION ALL

select ''''Server Role'''' as [RoleType],dbp1.name as [Role],dbp2.name as [Member],sl.name as [Login], sl.sid as [SID],1  from sys.server_role_members dbrm
join sys.server_principals dbp1 on dbp1.principal_id = dbrm.role_principal_id and dbp1.type= ''''R''''
join sys.server_principals dbp2 on dbp2.principal_id = dbrm.member_principal_id
join sys.syslogins sl on sl.sid = dbp2.sid
	
	
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
    DELETE [dbo].[SrvLogins]
    WHERE  SrvID = @SRVID
           AND CollectionDate < DATEADD(DD, -@D, GETDATE());
	DELETE FROM dbo.SrvRoleMembers
		WHERE SrvID = @SRVID
		AND CollectionDate < DATEADD(DD, -@D, GETDATE());
END