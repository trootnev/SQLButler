CREATE PROCEDURE [dbo].[CollectSrvData]
@SRV INT NULL=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SID AS INT;
    DECLARE @ERROR AS NVARCHAR (100);
    DECLARE @SERVNAME AS NVARCHAR (100);
    DECLARE SERV CURSOR
        FOR SELECT ServID
            FROM   Servers AS s
            WHERE  s.ACTIVE = -1
                   AND (ServID = @SRV
                        OR @SRV IS NULL);
    OPEN SERV;
    FETCH NEXT FROM SERV INTO @SID;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SERVNAME = (SELECT SERVNAME
                             FROM   dbo.Servers
                             WHERE  ServID = @SID);
            BEGIN TRY
                EXECUTE DBO.GetSrvVers @SID;
                EXECUTE dbo.SrvGetDbNames @SID;
                EXECUTE [dbo].[SrvGetJobs] @SID;
                EXECUTE [dbo].[GetSrvProperties] @SID;
                EXECUTE [dbo].[GetSrvConfigurations] @SID;
                EXECUTE [dbo].[CheckSrvSQLLogins] @SID;
                EXECUTE [dbo].[CollectSrvSQLAdmins] @SID;
                EXECUTE [dbo].[Collectlogins] @SID;

            END TRY
            BEGIN CATCH
                SET @ERROR = 'Server ' + @SERVNAME + ' had troubles:' + ERROR_MESSAGE();
                PRINT @ERROR;
            END CATCH
            FETCH NEXT FROM SERV INTO @SID;
        END
    CLOSE SERV;
    DEALLOCATE SERV;
	Exec [dbo].[CheckConfig4Changes]
END

