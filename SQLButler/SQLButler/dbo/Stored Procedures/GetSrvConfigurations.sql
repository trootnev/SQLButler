CREATE PROCEDURE [dbo].[GetSrvConfigurations]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 7;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT connstr
                    FROM   Servers AS s
                    WHERE  s.ServID = @SRVID);
    UPDATE dbo.InstanceConfiguration
    SET    is_current = 0
    WHERE  SrvID = @SrvID;
    SET @SQLStr = '
DECLARE @BatchID uniqueidentifier = (SELECT NEWID())

INSERT INTO [dbo].[InstanceConfiguration]
           (
           [BatchID]
           ,[SrvID]
           ,[configuration_id]
           ,[name]
           ,[value]
           ,[minimum]
           ,[maximum]
           ,[value_in_use]
           ,[description]
           ,[is_dynamic]
           ,[is_advanced]
           ,[is_current])

SELECT
 @BatchID
	 ,' + CAST (@SRVID AS NVARCHAR (50)) + '
	 ,[configuration_id]
	 ,[name]
	 ,[value]
	 ,[minimum]
	 ,[maximum]
	 ,[value_in_use]
	 ,[description]
	 ,[is_dynamic]
	 ,[is_advanced]
	 ,-1
FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
SELECT * FROM sys.configurations
''' + ')
';
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        PRINT @SQLStr;
        EXECUTE dbo.WriteErrorLog 7, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
    DECLARE @D AS INT;
    SELECT @D = IntValue
    FROM   dbo.Settings
    WHERE  [name] = 'ConfRetentionDays';
    DELETE dbo.InstanceConfiguration
    WHERE  SrvID = @SRVID
           AND Timestamp < DATEADD(DD, -@D, GETDATE());
END

