CREATE PROCEDURE [dbo].[GetSrvVers]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 1;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers
                    WHERE  ServID = @SRVID);
    SET @SQLStr = '
DECLARE @VERSION NVARCHAR (250)
SET @VERSION = (SELECT * FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''select @@version''' + '))
UPDATE Servers
Set
Version = @Version,
GetVersState = 1,
GetVersStateDesc = ''Success''
WHERE ServID = ' + CAST (@SRVID AS NVARCHAR (50));
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        --PRINT @SQLStr;
        UPDATE DBO.Servers
        SET    GetVersState     = ERROR_NUMBER(),
               GetVersStateDesc = ERROR_MESSAGE()
        WHERE  ServID = @SRVID;
        EXECUTE dbo.WriteErrorLog 1, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
END

