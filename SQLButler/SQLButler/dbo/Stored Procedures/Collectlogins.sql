CREATE PROCEDURE [dbo].[Collectlogins]
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

INSERT INTO [dbo].[SrvLogins]
           (
           [ID]
           ,[srvid]
		   ,[sid]
		   ,[LoginName]
           ,[Pass]
		  )

SELECT
 @ID
	 ,' + CAST (@SRVID AS NVARCHAR (50)) + '
	,[sid]
	,[loginname]
	,[password]


FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
select  [sid]
	,[loginname]
	,[password]
from sys.syslogins
WHERE hasaccess=1
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
END

