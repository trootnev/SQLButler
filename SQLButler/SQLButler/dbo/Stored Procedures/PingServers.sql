CREATE PROCEDURE [dbo].[PingServers]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ERROR AS INT;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @SRVID AS INT;
    DECLARE SRV CURSOR
        FOR SELECT ServID
            FROM   DBO.Servers
            WHERE  active = 0;
    OPEN SRV;
    FETCH NEXT FROM SRV INTO @SRVID;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @ERROR = 0;
            SET @Connstr = (SELECT connstr
                            FROM   dbo.Servers AS s
                            WHERE  s.ServID = @SRVID);
            SET @SQLStr = '
(SELECT * FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''select @@version''' + '))
';
            BEGIN TRY
                EXECUTE sp_executesql @SQLStr;
            END TRY
            BEGIN CATCH
                SET @ERROR = 1;
            END CATCH
            IF @ERROR = 0
                BEGIN
                    UPDATE dbo.Servers
                    SET    active = -1
                    WHERE  ServID = @SRVID;
                END
            FETCH NEXT FROM SRV INTO @SRVID;
        END
    CLOSE SRV;
    DEALLOCATE SRV;
END

