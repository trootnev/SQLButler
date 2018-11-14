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
	DECLARE @SQL NVARCHAR(255);
	DECLARE @ping int = 0
    DECLARE SERV CURSOR
        FOR SELECT ServID
            FROM   Servers AS s
            WHERE  s.ACTIVE = 1
                   AND (ServID = @SRV
                        OR @SRV IS NULL);
	CREATE TABLE  #PingStatus  
						(
						PingStatus int, 
						ErrorNumber int,
						ErrorMsg nvarchar(255)
						)

    OPEN SERV;
    FETCH NEXT FROM SERV INTO @SID;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SERVNAME = (SELECT SERVNAME
                             FROM   dbo.Servers
                             WHERE  ServID = @SID);
			DELETE #PingStatus
			EXEC dbo.PingInstance @SID

			IF (SELECT PingStatus FROM #PingStatus) = 1
				BEGIN
					BEGIN TRY
					
						EXECUTE DBO.GetSrvVers @SID;
						EXECUTE dbo.GetDbNames @SID;
						EXECUTE [dbo].[GetJobs] @SID;
						EXECUTE [dbo].[GetSrvProperties] @SID;
						EXECUTE [dbo].[GetSrvConfigurations] @SID;
						EXECUTE [dbo].[CheckSrvSQLLogins] @SID;
						EXECUTE [dbo].[GetSrvSQLAdmins] @SID;
						EXECUTE [dbo].[GetSrvPrincipals] @SID;
						EXECUTE [dbo].[GetSrvVolumes] @SID;
					END TRY
					BEGIN CATCH
						SET @ERROR = 'Server ' + @SERVNAME + ' had troubles:' + ERROR_MESSAGE();
						PRINT @ERROR;
					END CATCH
				END
			ELSE
				BEGIN
				SELECT @ERROR_CODE = ErrorNumber , @ERROR_MESS = ErrorMsg FROM #PingStatus
				exec WriteErrorLog 1,@SID, @ERROR_CODE,@ERROR_MESS
				UPDATE dbo.Servers
				SET GetVersState = 999,
				GetVersStateDesc =@ERROR_MESS
				,GetDBState = 999
				,GetDBStateDesc =@ERROR_MESS
				,GetDbFilesState = 999
				,GetDbFilesStateDesc =@ERROR_MESS
				,GetJobsState = 999
				,GetJobsStateDesc =@ERROR_MESS
				,GetJobsDetailsState = 999
				,GetJobsDetailsStateDesc=@ERROR_MESS
				WHERE ServID = @SID
				END
            FETCH NEXT FROM SERV INTO @SID;
        END
    CLOSE SERV;
    DEALLOCATE SERV;
	Exec [dbo].[CheckConfig4Changes]
	
	DROP TABLE #PingStatus
END