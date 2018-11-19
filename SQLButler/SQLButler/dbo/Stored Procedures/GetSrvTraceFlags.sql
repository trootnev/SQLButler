



-- =============================================
-- Description:	Процедура для получения активных глобальных флагов трассировки SQL Server
-- =============================================
CREATE PROCEDURE [dbo].[GetSrvTraceFlags] 
	
	@SRVID INT
AS
BEGIN
	

SET NOCOUNT ON;



DECLARE @Connstr NVARCHAR (100)
DECLARE @SQLStr NVARCHAR (MAX)
DECLARE @ACTIONTYPE INT
SET @ACTIONTYPE = 12
DECLARE @ERROR_CODE INT
DECLARE @ERROR_MESS NVARCHAR(400)


SET @Connstr = (SELECT dbo.ConnStr(ServName) FROM Servers s WHERE s.ServID = @SRVID)

UPDATE dbo.InstanceTraceFlags
 SET IsCurrent = 0
 WHERE SrvID= @SrvID
 
SET @SQLStr = '
DECLARE @BatchID uniqueidentifier = (SELECT NEWID())

INSERT INTO [dbo].[InstanceTraceFlags]
           (
           [BatchID]
           ,[SrvID]
           ,[TraceFlag]
           ,[IsCurrent])

SELECT
 @BatchID
	 ,'+CAST(@SRVID AS NVARCHAR (50))+'
	 ,[TraceFlag]
	 ,-1
FROM OPENROWSET(''SQLNCLI'',' +''''+ @Connstr +''''+', ' + '''

sp_executesql N''''
set fmtonly off;
SET NOCOUNT ON;
DECLARE   @TmpTraceStatus table(
  TraceFlag smallint
  ,status smallint
  ,global smallint
  ,session smallint );
 insert  INTO @TmpTraceStatus EXEC(''''''''DBCC TRACESTATUS'''''''');
  select * from  @TmpTraceStatus;
  ''''

''' + ')
'

BEGIN TRY

EXECUTE sp_executesql @SQLStr

END TRY
BEGIN CATCH
SET @ERROR_CODE = ERROR_NUMBER()
SET @ERROR_MESS = ERROR_MESSAGE()
PRINT @SQLStr

EXEC dbo.WriteErrorLog 7,@SRVID, @ERROR_CODE, @ERROR_MESS

END CATCH

--Cleanup History
DECLARE @D int
SELECT @D=IntValue FROM dbo.Settings 
WHERE [name] = 'ConfRetentionDays'

DELETE FROM dbo.InstanceTraceFlags
WHERE SrvID = @SRVID
AND Timestamp < DATEADD(DD,-@D,GETDATE())
   
END