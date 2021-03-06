﻿CREATE PROCEDURE [dbo].[GetSrvProperties]
@SRVID INT NULL
,@Debug bit = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
	DECLARE @Version NVARCHAR(200)
	DECLARE @Plus nvarchar(max) = '';
    SET @ACTIONTYPE = 6;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers AS s
                    WHERE  s.ServID = @SRVID);
	SELECT @Version = CASE WHEN [Version] like '%2008 R2 (RTM)%' or Version like '%- 10.0%' or Version like '%- 9.0%' THEN 'Old'
	ELSE 'New'
	END
	FROM dbo.Servers where ServId = @SRVID


	IF @Version = 'NEW'
	SET @Plus = 
	'UNION ALL
			
	select ''''SQLServerSvcAccount'''' as [pName], CAST(service_account as nvarchar(255))   as [pValue]
		from sys.dm_server_services
			where  filename like ''''%sqlservr.exe%'''' 
	UNION ALL 

	Select 
	''''SQLServerAgentSvcAccount'''' as [pName], CAST(service_account as nvarchar(255))   as [pValue]
		from sys.dm_server_services
			where  filename like ''''%SQLAGENT.EXE%'''' 
	UNION ALL
	SELECT

	''''SQLServerSvcStartType'''' as [pName], CAST(startup_type_desc as nvarchar(255))   as [pValue]
		from sys.dm_server_services
			where  filename like ''''%sqlservr.exe%'''' 
	UNION ALL

	SELECT
	''''SQLServerAgentSvcStartType'''' as [pName], CAST(startup_type_desc as nvarchar(255))   as [pValue]
		from sys.dm_server_services
			where  filename like ''''%SQLAGENT.EXE%'''' 
	'
	
    SET @SQLStr = '
DECLARE @t TABLE (pName nvarchar(255), [pValue] nvarchar(255))
DECLARE @clustered NVARCHAR (10)
DECLARE @ishadr NVARCHAR(10)
DECLARE @SrvID INT = ' + CAST (@SRVID AS NVARCHAR (MAX))+'

INSERT @t (pName, pValue)
(SELECT pName,pValue FROM OPENROWSET(''SQLOLEDB'',' + '''' + CAST(@Connstr AS NVARCHAR(MAX)) + '''' + ', ' + '''

SET FMTONLY OFF; SET NOCOUNT ON;


DECLARE @model TABLE (logdate datetime
		,ProcessInfo nvarchar(255)
		,[Text] nvarchar(255))
DECLARE @result TABLE (pName NVARCHAR(255)
						,pValue NVARCHAR(255))

INSERT @result (pName, pValue)
	(select distinct ''''LocalTcpPort'''' [pName],CAST(local_tcp_port as nvarchar(255))  as [pValue]
	from sys.dm_exec_connections 
		where local_net_address is not null
			AND protocol_type = ''''TSQL''''
			AND net_transport = ''''TCP''''
	'
	+@Plus+
	'
	UNION ALL 
		SELECT ''''InstanceCollation'''' as [pName], CAST(ServerProperty(''''collation'''') as nvarchar(255))   as [pValue]

	UNION ALL
		SELECT ''''IsHADREnabled'''' as [pName], CAST(ServerProperty(''''ishadrenabled'''') as nvarchar(255))   as [pValue]

	UNION ALL 
		SELECT ''''isClustered'''' as [pName], CAST(ServerProperty(''''isClustered'''') as nvarchar(255))   as [pValue]
	UNION ALL
		SELECT ''''CpuCount'''' as pName 
			,CAST(cpu_count  as NVARCHAR(255)) as pValue
			FROM sys.dm_os_sys_info
			UNION ALL
		SELECT ''''HyperthreadRatio'''' as pName
			,CAST(hyperthread_ratio  as NVARCHAR(255)) as pValue
			 FROM sys.dm_os_sys_info
			 UNION ALL
		SELECT ''''MaxWorkers'''' as pName
			,CAST(max_workers_count as NVARCHAR(255)) as pValue
			FROM sys.dm_os_sys_info	
		
		)

		INSERT @model (logdate
				,ProcessInfo
				, Text)
	EXEC xp_readerrorlog 0, 1, N''''System Model''''

	INSERT @result (pName, pValue)
	SELECT ''''SystemModel'''' as [pName]
		,[Text] as pValue
	FROM @model

	SELECT pName, pValue
		FROM @result


''' + '))


MERGE [dbo].[InstancePropertyTypes] AS TARGET
USING (SELECT pName from @t) as SOURCE(pName)
ON (TARGET.PropertyTypeName = SOURCE.pName)
WHEN NOT MATCHED THEN INSERT (PropertyTypeName)
VALUES (Source.pName); 

DECLARE @p nvarchar(255),
@v nvarchar(255)
DECLARE PAR CURSOR
FOR SELECT pName, pValue FROM @t

OPEN PAR

FETCH NEXT FROM PAR
INTO @p,@v

WHILE @@FETCH_STATUS = 0
BEGIN 

IF NOT EXISTS(SELECT 1 
				FROM [dbo].[InstanceProperties] ip
				JOIN dbo.InstancePropertyTypes ipt on ip.PropertyTypeID = ipt.PropertyTypeID
				 WHERE ip.SrvID = @SrvID  and ipt.PropertyTypeName = @p
				 and PropertyStringValue = @v and ip.IsCurrent = 1) 
BEGIN
UPDATE [dbo].[InstanceProperties] 
SET IsCurrent = 0
WHERE PropertyTypeID = (Select PropertyTypeID FROM dbo.InstancePropertyTypes where PropertyTypeName = @p)
AND SrvID = @SrvID
AND isCurrent = 1

INSERT INTO [dbo].[InstanceProperties]
           (
           [SrvID]
           ,[PropertyTypeID]
           ,[PropertyStringValue]
           )
   Select
		@SrvID
		,(SELECT PropertyTypeID FROM dbo.InstancePropertyTypes WHERE PropertyTypeName =@p)
		,PropertyStringValue = @v

END

UPDATE dbo.InstanceProperties
SET PropertyDate = GETDATE()
WHERE SrvId = @SrvId
	AND IsCurrent = 1
	AND PropertyDate < DATEADD(HH,-1,GETDATE())

FETCH NEXT FROM PAR
INTO @p,@v

END

CLOSE PAR
DEALLOCATE PAR

SELECT @clustered = pValue FROM @t WHERE pName = ''IsClustered''
SELECT @ishadr = pValue FROM @t WHERE pName = ''IsHADREnabled''

UPDATE Servers
Set
IsClustered = @clustered,
IsHADREnabled = @ishadr

WHERE ServID = @SrvID';
   IF @Debug = 0 
   BEGIN
    BEGIN TRY
        EXEC(@SQLStr);
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        PRINT @SQLStr;
		PRINT @ERROR_MESS
        EXECUTE dbo.WriteErrorLog 6, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
	END
	ELSE
	PRINT @SQLStr
END

