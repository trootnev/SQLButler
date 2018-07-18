CREATE PROCEDURE [dbo].[GetSrvVers_debug]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    SET @Connstr = (SELECT connstr
                    FROM   Servers AS s
                    WHERE  s.ServID = @SRVID);
    SET @SQLStr = '
DECLARE @VERSION NVARCHAR (50)
SET @VERSION = (SELECT * FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''select @@version''' + '))
UPDATE Servers
Set
Version = @Version,
GetVersState = 1,
GetVersStateDesc = ''Success''
WHERE ServID = ' + CAST (@SRVID AS NVARCHAR (50));
    BEGIN TRY
        PRINT @SQLSTR;
    END TRY
    BEGIN CATCH
        UPDATE DBO.Servers
        SET    GetVersState     = ERROR_NUMBER(),
               GetVersStateDesc = ERROR_MESSAGE();
    END CATCH
END

