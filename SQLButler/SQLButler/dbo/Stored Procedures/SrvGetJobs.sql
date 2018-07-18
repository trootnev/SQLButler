CREATE PROCEDURE [dbo].[SrvGetJobs]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQLSTR AS NVARCHAR (MAX);
    DECLARE @Connstr AS NVARCHAR (MAX);
    SET @Connstr = (SELECT connstr
                    FROM   Servers
                    WHERE  ServID = @SRVID);
    SET @SQLSTR = '
DECLARE @jid NVARCHAR(250)
DECLARE @JNAME NVARCHAR(MAX)
DECLARE @CAT NVARCHAR (150)

DECLARE JOBS CURSOR
		FOR
		SELECT * FROM OPENROWSET(''SQLNCLI'',' + '''' + @Connstr + '''' + ', ' + '''select jobs.job_id, jobs.name as JobName, cat.name as category
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
    EXECUTE sp_executesql @SQLSTR;
END

