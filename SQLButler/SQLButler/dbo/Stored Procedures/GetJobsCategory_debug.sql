CREATE PROCEDURE [dbo].[GetJobsCategory_debug]
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
                             WHERE  active = -1)
                   AND CatOverride = 0;
    OPEN JOBS;
    FETCH NEXT FROM JOBS INTO @SRVID, @JID;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SERVNAME = (SELECT ServName
                             FROM   dbo.Servers
                             WHERE  ServID = @SRVID);
            SET @Connstr = (SELECT connstr
                            FROM   dbo.Servers
                            WHERE  ServID = @SRVID);
            SET @SQLSTR = '
	IF EXISTS(
	Select 1 FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
select jobs.name, jobs.job_id
FROM msdb.dbo.sysjobsteps steps join msdb.dbo.sysjobs jobs on steps.job_id = jobs.job_id
JOIN msdb.dbo.syscategories cat on jobs.category_id = cat.category_id
JOIN msdb.dbo.sysjobhistory hist on hist.job_id = jobs.job_id
WHERE jobs.job_id =''''' + CAST (@jid AS NVARCHAR (150)) + '''''
AND jobs.name not like ''''syspolicy_purge_history''''
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
Select 1 FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''
select 1 from msdb..sysjobs where job_id = ''''' + CAST (@jid AS NVARCHAR (150)) + '''''
AND category_id not in (0,2,98,99)''))
BEGIN
		UPDATE dbo.SrvJobs
		SET 
		IsSystem = -1
		WHERE 
		jid = ''' + CAST (@jid AS NVARCHAR (150)) + '''
		AND
		SRVID = ' + CAST (@SRVID AS NVARCHAR (150)) + '
		END

ELSE
BEGIN
UPDATE dbo.SrvJobs
		SET 
		IsSystem = 0
		WHERE 
		jid = ''' + CAST (@jid AS NVARCHAR (150)) + '''
		AND
		SRVID = ' + CAST (@SRVID AS NVARCHAR (150)) + '
		END
		';
            BEGIN TRY
                EXECUTE sp_executesql @SQLSTR;
            END TRY
            BEGIN CATCH
                SET @ERROR = 'Server ' + @SERVNAME + ' UNREACHABLE' + CAST (GETDATE() AS NVARCHAR (MAX));
                PRINT @ERROR;
            END CATCH
            FETCH NEXT FROM JOBS INTO @SRVID, @JID;
        END
    CLOSE JOBS;
    DEALLOCATE JOBS;
END

