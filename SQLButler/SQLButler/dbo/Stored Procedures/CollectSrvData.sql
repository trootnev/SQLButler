CREATE PROCEDURE [dbo].[CollectSrvData]
@SRV INT NULL=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SID AS INT;
    DECLARE @ERROR AS NVARCHAR (100);
    DECLARE @SERVNAME AS NVARCHAR (100);
	DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (255);
	DECLARE @ping int = 0
    DECLARE SERV CURSOR
        FOR SELECT ServID
            FROM   Servers AS s
            WHERE  s.ACTIVE = 1
                   AND (ServID = @SRV
                        OR @SRV IS NULL);
    OPEN SERV;
    FETCH NEXT FROM SERV INTO @SID;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SERVNAME = (SELECT SERVNAME
                             FROM   dbo.Servers
                             WHERE  ServID = @SID);
			
			EXEC  dbo.PingInstance  @SID, @ping OUTPUT
			IF @ping = 1
				BEGIN
					BEGIN TRY
						EXECUTE DBO.GetSrvVers @SID;
						EXECUTE dbo.SrvGetDbNames @SID;
						EXECUTE [dbo].[SrvGetJobs] @SID;
						EXECUTE [dbo].[GetSrvProperties] @SID;
						EXECUTE [dbo].[GetSrvConfigurations] @SID;
						EXECUTE [dbo].[CheckSrvSQLLogins] @SID;
						EXECUTE [dbo].[CollectSrvSQLAdmins] @SID;
						EXECUTE [dbo].[CollectSrvPrincipals] @SID;
						EXECUTE [dbo].[CollectSrvVolumes] @SID;
					END TRY
					BEGIN CATCH
						SET @ERROR = 'Server ' + @SERVNAME + ' had troubles:' + ERROR_MESSAGE();
						PRINT @ERROR;
					END CATCH
				END
			ELSE
				BEGIN
				exec WriteErrorLog 1,@SID, 999, 'Server is not responding to @@version request.' 
				UPDATE dbo.Servers
				SET GetVersState = 999,
				GetVersStateDesc = 'Server is not responding to @@version request.' 
				,GetDBState = 999
				,GetDBStateDesc = 'Server is not responding to @@version request.' 
				,GetDbFilesState = 999
				,GetDbFilesStateDesc = 'Server is not responding to @@version request.' 
				,GetJobsState = 999
				,GetJobsStateDesc = 'Server is not responding to @@version request.' 
				,GetJobsDetailsState = 999
				,GetJobsDetailsStateDesc= 'Server is not responding to @@version request.' 
				WHERE ServID = @SID
				END
            FETCH NEXT FROM SERV INTO @SID;
        END
    CLOSE SERV;
    DEALLOCATE SERV;
	Exec [dbo].[CheckConfig4Changes]
END

