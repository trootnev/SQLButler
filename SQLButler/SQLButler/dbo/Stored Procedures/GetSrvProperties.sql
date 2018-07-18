CREATE PROCEDURE [dbo].[GetSrvProperties]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 6;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT connstr
                    FROM   Servers AS s
                    WHERE  s.ServID = @SRVID);
    SET @SQLStr = '
DECLARE @clustered NVARCHAR (10)
DECLARE @ishadr NVARCHAR(10)
SET @clustered = (SELECT * FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
Select CAST(SERVERPROPERTY(''''isClustered'''') as NVARCHAR(10))

''' + '))
SET @ishadr = (SELECT * FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
Select CAST(SERVERPROPERTY(''''ishadrenabled'''') as NVARCHAR(10))

''' + '))

UPDATE Servers
Set
IsClustered = @clustered,
IsHADREnabled = @ishadr

WHERE ServID = ' + CAST (@SRVID AS NVARCHAR (50));
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        PRINT @SQLStr;
        EXECUTE dbo.WriteErrorLog 6, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
END

