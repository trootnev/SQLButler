



CREATE   PROCEDURE [dbo].[NodesCompare] @servers varchar(max) = NULL

AS

declare @servernames table(name nvarchar(128))
INSERT INTO @servernames select value from string_split(@servers,',')  order by value desc

--version (@@VERSION)

SELECT N'Различия в версиях серверов (@@VERSION):' as '1'

CREATE TABLE [#filtered_v](
	[SrvID] [int] NULL,
	[ServName] [nvarchar](100) collate database_default NOT NULL,
	[Version] [nvarchar](250) collate database_default NOT NULL
) ON [PRIMARY]

INSERT INTO #filtered_v
SELECT 
ss.ServID,
ss.ServName,
ss.Version

FROM [Servers] ss
JOIN @servernames sn ON ss.ServName=sn.name


SELECT f1.ServName SQLServer1
	,f2.ServName SQLServer2
	,f1.Version
	,f2.Version
FROM #filtered_v f1
JOIN #filtered_v f2 ON (
			 f1.SRVID > f2.SRVID
		AND (
			f1.Version <> f2.Version
				)
		)
ORDER BY f1.Servname

  
DROP TABLE  #filtered_v

--TraceFlags (DBCC TRACESTATUS)

SELECT N'Различия во флагах трассировки (DBCC TRACESTATUS), список флагов включенных не на всех серверах:' as '2'

CREATE TABLE [#filtered_t](
	[SrvID] [int] NULL,
	[ServName] [nvarchar](100) collate database_default NOT NULL,
	[TraceFlag] [sql_variant] NOT NULL,
	[Change_Detected_Time] [datetime] NOT NULL
) ON [PRIMARY]

INSERT INTO #filtered_t
SELECT 
ic.SrvID,
ss.ServName,
ic.[TraceFlag] as Parameter,
ic.timestamp as Change_Detected_Time

FROM [InstanceTraceFlags] as ic

JOIN [Servers] ss on [ic].srvid=ss.ServID 
JOIN @servernames sn ON ss.ServName=sn.name
WHERE IsCurrent=1


SELECT f1.ServName,
		f1.TraceFlag,
 	f1.Change_Detected_Time
FROM #filtered_t f1
JOIN (
SELECT    
f.TraceFlag, count(*) cnt
FROM #filtered_t f
GROUP BY  
f.TraceFlag
HAVING COUNT(*)<(select count(*) FROM @servernames)
) diff on f1.TraceFlag=diff.TraceFlag
ORDER BY Servname

  
DROP TABLE  #filtered_t

-- config (InstanceConfiguration)

SELECT N'Различия в конфигурациях серверов (sys.configurations):' as '3'

CREATE TABLE [#filtered_c](
	[SrvID] [int] NULL,
	[ServName] [nvarchar](100) collate database_default NOT NULL,
	[Parameter] [nvarchar](35) NOT NULL,
	[Change_Detected_Time] [datetime] NOT NULL,
	[configuration_id] [int] NOT NULL,
	[value] [sql_variant] NULL,
	[Value_In_Use] [sql_variant] NULL
) ON [PRIMARY]

INSERT INTO #filtered_c
SELECT 
ic.SrvID,
ss.ServName,
ic.ConfigurationName as Parameter,
ic.CollectionDate as Change_Detected_Time,
ic.ConfigurationId,
ic.ConfigurationValue,
ic.ConfigurationValueInUse as Value_In_Use

FROM InstanceConfiguration as ic

join 
(	select SrvID, max(InstanceConfiguration.CollectionDate) timestamp
	from  [dbo].[InstanceConfiguration]
	join [Servers] on [InstanceConfiguration].srvid=[Servers].ServID
	group by SrvID
)ts on (ts.timestamp=ic.CollectionDate and  ts.SrvID=ic.SrvID) 
JOIN [Servers] ss on [ic].srvid=ss.ServID 
JOIN SrvGroup sg on [ss].ServGroup=sg.sgid 
JOIN @servernames sn ON ss.ServName=sn.name


SELECT f1.ServName SQLServer1
	,f2.ServName SQLServer2
	,f1.Parameter
	--,f1.value AS value1
	,f1.Value_In_Use SQLServer1_Value
	--,f2.value AS value1
	,f2.Value_In_Use SQLServer2_Value
	,f1.Change_Detected_Time
FROM #filtered_c f1
JOIN #filtered_c f2 ON (
		f1.configuration_id = f2.configuration_id
		AND f1.SRVID > f2.SRVID
		AND (
			f1.value <> f2.value
			OR f1.value_in_use <> f2.value_in_use
			)
		)
ORDER BY f1.Servname

  
DROP TABLE  #filtered_c


---- files (DbFiles)

SELECT N'Различия в настройках файлов БД (sys.database_files):' as '4'

CREATE TABLE [#filtered_d](
	[SrvID] [int] NOT NULL,
	[ServName] [nvarchar](100)  collate database_default NOT NULL,
	[DbName] [nvarchar](50) NULL,
	[filename] [sysname] NOT NULL,
	[file] [nvarchar](255) NOT NULL,
	[size] [int] NOT NULL,
	[DBID] [int] NOT NULL,
	[fileid] [int] NOT NULL,
	[maxsize] [int] NOT NULL,
	[growth] [int] NOT NULL,
	[is_percent_growth] [bit] NOT NULL,
	[RecMod] [int] NULL,
	[Change_Detected_Time] [datetime] NOT NULL
) ON [PRIMARY]


INSERT INTO #filtered_d
SELECT ss.ServID, ss.ServName ServName, sd.DbName,  df.FileName as filename, df.filename as [file], FileSize, sd.DbID, df.InternalFileID fileid,  FileMaxSize,  FileGrowth, IsPercentGrowth, RecMod, MeasureDate as [Change_Detected_Time]
  FROM [Inventory].[dbo].[DbFiles] df
JOIN [dbo].[SrvDB] sd on df.DbId=sd.DbID
JOIN [Servers] ss on [sd].srvid=ss.ServID 
JOIN
(	select sd.DbId,SrvID, InternalFileID, max(MeasureDate) timestamp
	from  [DbFiles] df
	JOIN [dbo].[SrvDB] sd on df.DbId=sd.DbID
    JOIN [Servers] ss on [sd].srvid=ss.ServID 
	group by SrvID, Sd.DbId,InternalFileID
)ts ON df.MeasureDate=ts.timestamp AND ss.ServID=ts.SrvID AND df.DbId=ts.DbId AND df.InternalFileID=ts.InternalFileID
JOIN @servernames sn ON ss.ServName=sn.name


--same DBS
/*
SELECT f1.ServName SQLServer1, f2.ServName SQLServer2, f1.DbName, f1.fileid, f1.Change_Detected_Time,   
f1.filename filename1, f1.size size1, f1.maxsize maxsize1, f1.growth growth1, f1.is_percent_growth is_percent_growth1, f1.RecMod RecMod1,
f2.filename filename2, f2.size size2, f2.maxsize maxsize2, f2.growth growth2, f2.is_percent_growth is_percent_growth2, f2.RecMod RecMod2
FROM #filtered_d f1
JOIN #filtered_d f2 ON (f1.DbName=f2.DbName AND f1.fileid=f2.fileid AND f1.SRVID<f2.SRVID)
 AND (f1.filename <> f2.filename OR f1.size <> f2.size OR f1.maxsize <> f2.maxsize OR f1.growth <> f2.growth OR f1.is_percent_growth <> f2.is_percent_growth OR f1.RecMod <> f2.RecMod) 
  
ORDER BY f1.Servname
*/

--all DBs




SELECT f.ServName, f.DbName, f.fileid, f.Change_Detected_Time,   
f.filename, f.size, f.maxsize , f.growth , f.is_percent_growth , f.RecMod 
FROM #filtered_d f
JOIN (
SELECT    
f.filename , f.size , f.maxsize , f.growth , f.is_percent_growth , f.RecMod , count(*) cnt
FROM #filtered_d f
WHERE f.DbName IN (SELECT DBNAME FROM  (SELECT distinct Servname, DbName FROM  #filtered_d) tem_dbs group by  DbName HAVING COUNT(*)=(select count(*) FROM @servernames)) --only these dbs which exists on all servers
GROUP BY 
f.filename, f.size , f.maxsize , f.growth , f.is_percent_growth , f.RecMod 
HAVING COUNT(*)<(select count(*) FROM @servernames)
) diff on f.filename=diff.filename AND f.size=diff.size AND f.maxsize=diff.maxsize AND f.growth=diff.growth AND f.is_percent_growth=diff.is_percent_growth AND f.RecMod=diff.RecMod 
ORDER BY Servname

DROP table #filtered_d


---- logins (SrvLogins)

SELECT N'Различия в логинах (sys.syslogins):' as '5'


CREATE TABLE [dbo].[#filtered_l](
	[servid] [int] NOT NULL,
	[ServName] [nvarchar](100)  collate database_default NOT NULL,
	[sid] [varbinary](256) NULL,
	[LoginName] [nvarchar](50) NULL,
	[collected_time] [datetime] NULL,
	[sa] bit NULL
) ON [PRIMARY]



INSERT INTO #filtered_l
SELECT ss.servid, ss.ServName, sl.sid, LoginName, ts.timestamp as collected_time,
CASE
WHEN CSS.SrvID=sl.srvid THEN 1
WHEN CSS.srvid IS NULL THEN 0
END sa
 FROM [dbo].[SrvLogins] sl
JOIN [Servers] ss on sl.srvid=ss.ServID 
JOIN
(	select SrvID, sid, max(collectiondate) timestamp
	from  [SrvLogins]
	group by SrvID, sid
) ts ON sl.collectiondate=ts.timestamp AND ss.ServID=ts.SrvID AND sl.sid=ts.sid
LEFT JOIN
(	select SrvID, SAName
	from  [Compliance_SrvSysadmins]
	WHERE IsCurrent=1
	) CSS ON  ss.ServID=CSS.SrvID AND sl.LoginName=CSS.SAName
JOIN @servernames sn ON ss.ServName=sn.name


/*

with passwords - need to check passwords fields comparison

SELECT f.servid, f.ServName, 
f.sid, f.LoginName, f.Pass, f.collected_time
FROM #filtered_l f
JOIN (
SELECT    
f.sid, f.LoginName, f.Pass, count(*) cnt
FROM #filtered_l f
GROUP BY 
f.sid, f.LoginName, f.Pass 
HAVING COUNT(*)<(select count(*) FROM @servernames)
) diff on f.sid=diff.sid AND f.LoginName=diff.LoginName AND f.pass=diff.pass --PWDCOMPARE(f.pass,diff.pass)=0
ORDER BY Servname

*/

SELECT f.servid, f.ServName, 
f.sid, f.LoginName,f.collected_time, f.sa
FROM #filtered_l f 
JOIN (
SELECT    
f.sid, f.LoginName, f.sa, count(*) cnt
FROM #filtered_l f
GROUP BY  
f.sid, f.LoginName, f.sa
HAVING COUNT(*)<(select count(*) FROM @servernames)
) diff on f.sid=diff.sid AND f.LoginName=diff.LoginName  AND f.sa=diff.sa--PWDCOMPARE(f.pass,diff.pass)=0
WHERE f.Loginname not like '##%'
ORDER BY Servname


DROP table #filtered_l




---- jobs (SrvJobs)

SELECT N'Различия в заданиях (sys.jobs), список заданий существующих не на всех серверах:' as '6'
 
CREATE TABLE [dbo].[#filtered_j](
	[servid] [int] NOT NULL,
	[ServName] [nvarchar](100) NOT NULL,
	[job_name] [nvarchar](250) NULL,
) ON [PRIMARY]


INSERT INTO #filtered_j
SELECT  ss.servid, ss.ServName, sj.JobName
 FROM [dbo].[SrvJobs] sj
JOIN [Servers] ss on sj.srvid=ss.ServID 
JOIN @servernames sn ON ss.ServName=sn.name


SELECT f.servid, f.ServName, 
f.job_name
FROM #filtered_j f 
JOIN (
SELECT    
f.job_name,  count(*) cnt
FROM #filtered_j f
GROUP BY  
f.job_name
HAVING COUNT(*)<(select count(*) FROM @servernames)
) diff on f.job_name=diff.job_name --AND f.LoginName=diff.LoginName  --PWDCOMPARE(f.pass,diff.pass)=0
ORDER BY Servname

DROP table #filtered_j


--EXEC [dbo].[NodesCompare] 'MGTS-SV01,MGTS-SV02'