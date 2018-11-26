CREATE PROCEDURE [dbo].[GetJobsInfo]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @JID AS UNIQUEIDENTIFIER;
    DECLARE @SRVID AS INT;
    DECLARE @SQLSTR AS NVARCHAR (MAX);
    DECLARE @Connstr AS NVARCHAR (MAX);
    DECLARE @ERROR AS NVARCHAR (100);
    DECLARE @SERVNAME AS NVARCHAR (100);
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (250);
    DECLARE JOBS CURSOR FORWARD_ONLY READ_ONLY FAST_FORWARD
        FOR SELECT   sj.SrvID,
                     sj.JobID,
                     dbo.ConnStr(s.ServName),
                     s.ServName
            FROM     dbo.SrvJobs AS SJ
                     INNER JOIN
                     dbo.Servers AS s
                     ON SJ.srvid = s.ServID
            WHERE    s.IsActive = 1
                     AND sj.CatOverride = 0
					 AND s.GetVersState = 1
            ORDER BY sj.srvid;
    OPEN JOBS;
    FETCH NEXT FROM JOBS INTO @SRVID, @JID, @CONNSTR, @SERVNAME;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SQLSTR = '
	
DECLARE @CAT NVARCHAR(150)
DECLARE @RUNSTATUS INT
DECLARE @LRD NVARCHAR(150) 
DECLARE @STUB UNIQUEIDENTIFIER
	
	Select @STUB = jobid, @CAT = Category, @RUNSTATUS = RunStatus, @LRD = Lastrundate FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''
				select top 1 jobs.job_id as JobID, cat.name as category , hist.run_status as RunStatus, MAX(hist.run_date) as LastRunDate
FROM msdb.dbo.sysjobsteps steps join msdb.dbo.sysjobs jobs on steps.job_id = jobs.job_id
JOIN msdb.dbo.syscategories cat on jobs.category_id = cat.category_id
JOIN msdb.dbo.sysjobhistory hist on hist.job_id = jobs.job_id
WHERE jobs.job_id =''''' + CAST (@jid AS NVARCHAR (150)) + '''''
Group by jobs.job_id,cat.name, hist.run_status, hist.run_date
ORDER BY hist.run_date desc''' + ');

		UPDATE dbo.SrvJobs
		SET 
		JobCategory = @CAT,
		LastOutcome = @RUNSTATUS,
		LastRunDate = CAST(@LRD as DATE)
		WHERE 
		JobID = ''' + CAST (@jid AS NVARCHAR (150)) + '''
		AND
		SrvID = ' + CAST (@SRVID AS NVARCHAR (150)) + '
		';
            SET @ERROR_CODE = 0;
            BEGIN TRY
                EXECUTE sp_executesql @SQLSTR;
            END TRY
            BEGIN CATCH
                SET @ERROR_CODE = ERROR_NUMBER();
                SET @ERROR_MESS = ERROR_MESSAGE();
                EXECUTE dbo.WriteErrorLog 4, @SRVID, @ERROR_CODE, @ERROR_MESS;
                UPDATE dbo.Servers
                SET    GetJobsState     = ERROR_NUMBER(),
                       GetJobsStateDesc = ERROR_MESSAGE()
                WHERE  ServID = @SRVID;
            END CATCH
            IF @ERROR_CODE = 0
                UPDATE dbo.Servers
                SET    GetJobsState     = 1,
                       GetJobsStateDesc = 'Success'
                WHERE  ServID = @SRVID;
            FETCH NEXT FROM JOBS INTO @SRVID, @JID, @CONNSTR, @SERVNAME;
        END
    CLOSE JOBS;
    DEALLOCATE JOBS;
END

