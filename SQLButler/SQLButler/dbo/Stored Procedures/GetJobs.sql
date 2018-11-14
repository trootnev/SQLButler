CREATE PROCEDURE [dbo].[GetJobs]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQLSTR AS NVARCHAR (MAX);
    DECLARE @Connstr AS NVARCHAR (1000);
	 DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers
                    WHERE  ServID = @SRVID);
    SET @SQLSTR = '
DECLARE @jid NVARCHAR(250)
DECLARE @JNAME NVARCHAR(MAX)
DECLARE @CAT NVARCHAR (150)

DECLARE JOBS CURSOR
		FOR
		SELECT * FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''select jobs.job_id, jobs.name as JobName, cat.name as category
FROM msdb.dbo.sysjobsteps steps join msdb.dbo.sysjobs jobs on steps.job_id = jobs.job_id
JOIN msdb.dbo.syscategories cat on jobs.category_id = cat.category_id
WHERE jobs.name != ''''syspolicy_purge_history''''
Group by jobs.job_id,jobs.name,cat.name''' + ');
OPEN JOBS;
FETCH NEXT FROM JOBS
INTO @JID, @JNAME, @CAT
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (SELECT 1 FROM DBO.SrvJobs WHERE SrvId =' + CAST (@SRVID AS NVARCHAR (10)) + ' AND jid = @JID )
	Insert into dbo.SrvJobs
	(srvid,
	jid,
	job_name)
	VALUES (' + CAST (@SRVID AS NVARCHAR (10)) + ', @JID,@JNAME)
	
	UPDATE dbo.SrvJobs
	SET job_name = @JNAME
	where Srvid = ' + CAST (@SRVID AS NVARCHAR (10)) + '
	AND jid = @JID
	AND job_name <> @JNAME 	
FETCH NEXT FROM JOBS
INTO @JID, @JNAME, @CAT
END
CLOSE JOBS;
DEALLOCATE JOBS
';
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
                SET @ERROR_CODE = ERROR_NUMBER();
                SET @ERROR_MESS = ERROR_MESSAGE();
                EXECUTE dbo.WriteErrorLog 4, @SRVID, @ERROR_CODE, @ERROR_MESS;
                UPDATE DBO.Servers
                SET    GetJobsState     = ERROR_NUMBER(),
                       GetJobsStateDesc = ERROR_MESSAGE()
                WHERE  ServID = @SRVID;
            END CATCH
            IF @ERROR_CODE = 0
                UPDATE DBO.Servers
                SET    GetJobsState     = 1,
                       GetJobsStateDesc = 'Success'
                WHERE  ServID = @SRVID;
    
END

