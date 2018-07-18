CREATE PROCEDURE [dbo].[GetJobsInfoForAll_debug]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @JID AS UNIQUEIDENTIFIER;
    DECLARE @SRVID AS INT;
    DECLARE @SQLSTR AS NVARCHAR (MAX);
    DECLARE @Connstr AS NVARCHAR (MAX);
    DECLARE @ERROR AS NVARCHAR (100);
    DECLARE @SERVNAME AS NVARCHAR (100);
    DECLARE JOBS CURSOR FORWARD_ONLY READ_ONLY FAST_FORWARD
        FOR SELECT SrvID,
                   jid
            FROM   dbo.SrvJobs
            WHERE  SrvID IN (SELECT servid
                             FROM   dbo.Servers
                             WHERE  active = -1);
    OPEN JOBS;
    FETCH NEXT FROM JOBS INTO @SRVID, @JID;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SERVNAME = (SELECT ServName
                             FROM   dbo.Servers
                             WHERE  ServID = @SRVID);
            PRINT 'SERVER: ' + CAST (@SRVID AS NVARCHAR (20));
            SET @Connstr = (SELECT connstr
                            FROM   dbo.Servers
                            WHERE  ServID = @SRVID);
            SET @SQLSTR = '
	
DECLARE @CAT NVARCHAR(150)
DECLARE @RUNSTATUS INT
DECLARE @LRD NVARCHAR(150) 
DECLARE @STUB UNIQUEIDENTIFIER
	
	Select @STUB = jobid, @CAT = Category, @RUNSTATUS = RunStatus, @LRD = Lastrundate FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
				select top 1 jobs.job_id as JobID, cat.name as category , hist.run_status as RunStatus, MAX(hist.run_date) as LastRunDate
FROM msdb.dbo.sysjobsteps steps join msdb.dbo.sysjobs jobs on steps.job_id = jobs.job_id
JOIN msdb.dbo.syscategories cat on jobs.category_id = cat.category_id
JOIN msdb.dbo.sysjobhistory hist on hist.job_id = jobs.job_id
WHERE jobs.job_id =''''' + CAST (@jid AS NVARCHAR (150)) + '''''
Group by jobs.job_id,cat.name, hist.run_status, hist.run_date
ORDER BY hist.run_date desc''' + ');

		UPDATE dbo.SrvJobs
		SET 
		category = @CAT,
		Lastresult = @RUNSTATUS,
		LastRunDate = CAST(@LRD as DATE)
		WHERE 
		jid = ''' + CAST (@jid AS NVARCHAR (150)) + '''
		AND
		SRVID = ' + CAST (@SRVID AS NVARCHAR (150)) + '
		';
            BEGIN TRY
                PRINT @SQLSTR;
            END TRY
            BEGIN CATCH
                SELECT Getdate() AS MeasureDate,
                       @Servname AS [Server],
                       ERROR_MESSAGE() AS ErrorMessage;
            END CATCH
            FETCH NEXT FROM JOBS INTO @SRVID, @JID;
        END
    CLOSE JOBS;
    DEALLOCATE JOBS;
END

