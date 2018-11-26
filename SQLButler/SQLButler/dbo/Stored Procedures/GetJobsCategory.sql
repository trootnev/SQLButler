CREATE PROCEDURE [dbo].[GetJobsCategory]
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
            ORDER BY sj.srvid;
    OPEN JOBS;
    FETCH NEXT FROM JOBS INTO @SRVID, @JID, @connstr, @ServName;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SQLSTR = '
	IF EXISTS(
	Select 1 FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''
select jobs.name, jobs.job_id
FROM msdb.dbo.sysjobsteps steps join msdb.dbo.sysjobs jobs on steps.job_id = jobs.job_id
JOIN msdb.dbo.syscategories cat on jobs.category_id = cat.category_id
JOIN msdb.dbo.sysjobhistory hist on hist.job_id = jobs.job_id
WHERE jobs.job_id =''''' + CAST (@jid AS NVARCHAR (150)) + '''''
and(
command like ''''%BACKUP%'''' 
or command like ''''%RESTORE%''''
or command like ''''%REPL%'''' 
or command like ''''%SHRINKFILE%''''
or command like ''''%SHRINKDATABASE%''''
OR command like ''''%REINDEX%'''' 
or cat.name like ''''%Backup%''''
or cat.name like ''''%REPL%'''' 
or cat.name like ''''%Log Shipping%''''
or cat.name like ''''%Database Maintenance%''''
or jobs.name like ''''%Reinitialize subscriptions having data validation failures%'''')''' + '))

OR EXISTS(
Select 1 FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''
select 1 from msdb..sysjobs where job_id = ''''' + CAST (@jid AS NVARCHAR (150)) + '''''
AND category_id not in (0,2,98,99)''))
BEGIN
		UPDATE dbo.SrvJobs
		SET 
		IsSystem = -1
		WHERE 
		JobID = ''' + CAST (@jid AS NVARCHAR (150)) + '''
		AND
		SrvID = ' + CAST (@SRVID AS NVARCHAR (150)) + '
		END

ELSE
BEGIN
UPDATE dbo.SrvJobs
		SET 
		IsSystem = 0
		WHERE 
		JobID = ''' + CAST (@jid AS NVARCHAR (150)) + '''
		AND
		SrvID = ' + CAST (@SRVID AS NVARCHAR (150)) + '
		END
		';
            SET @ERROR_CODE = 0;
            BEGIN TRY
                EXECUTE sp_executesql @SQLSTR;
            END TRY
            BEGIN CATCH
                SET @ERROR_CODE = ERROR_NUMBER();
                SET @ERROR_MESS = ERROR_MESSAGE();
                EXECUTE dbo.WriteErrorLog 5, @SRVID, @ERROR_CODE, @ERROR_MESS;
                UPDATE dbo.Servers
                SET    GetJobsDetailsState     = ERROR_NUMBER(),
                       GetJobsDetailsStateDesc = ERROR_MESSAGE()
                WHERE  ServID = @SRVID;
            END CATCH
            IF @ERROR_CODE = 0
                UPDATE dbo.Servers
                SET    GetJobsDetailsState     = 1,
                       GetJobsDetailsStateDesc = 'Success'
                WHERE  ServID = @SRVID;
            FETCH NEXT FROM JOBS INTO @SRVID, @JID, @connstr, @ServName;
        END
    CLOSE JOBS;
    DEALLOCATE JOBS;
END

