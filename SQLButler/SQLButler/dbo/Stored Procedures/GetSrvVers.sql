CREATE PROCEDURE [dbo].[GetSrvVers]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 1;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers
                    WHERE  ServID = @SRVID);
    SET @SQLStr = '
DECLARE @SrvID INT = ' + CAST (@SRVID AS NVARCHAR (50))+'

DECLARE @Version NVARCHAR (250)
DECLARE @RawVersion NVARCHAR(250)
DECLARE @Edition nvarchar(250)
DECLARE @ProductLevel nvarchar(255)

DECLARE @t TABLE (pName nvarchar(255), [pValue] nvarchar(255))

 (SELECT @Version = Version,
		 @RawVersion = RawVersion,
		 @Edition = Edition,
		 @ProductLevel = ProductLevel
 FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''

	SELECT CAST(@@Version as nvarchar(250)) as RawVersion
			 ,CAST(SERVERPROPERTY(''''Edition'''') as NVARCHAR(250)) as Edition
			 ,CAST(SERVERPROPERTY(''''ProductVersion'''') as NVARCHAR(250)) as Version
			 ,CAST(SERVERPROPERTY(''''ProductLevel'''') as NVARCHAR(250)) as ProductLevel
			

''' + '))

INSERT @t (pName, pValue)
VALUES 

(''DBEngineVersion'', @Version),
(''DBEngineEdition'',@Edition),
(''DBEngineProductLevel'',@ProductLevel),
(''DBEngineVersionRaw'', @RawVersion)


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


UPDATE dbo.InstanceProperties
SET PropertyDate = GETDATE()
WHERE SrvId = @SrvId
	AND IsCurrent = 1
	AND PropertyDate < DATEADD(HH,-1,GETDATE())


END

FETCH NEXT FROM PAR
INTO @p,@v

END

CLOSE PAR
DEALLOCATE PAR


UPDATE Servers
Set
Version = @Version,
GetVersState = 1,
GetVersStateDesc = ''Success''
WHERE ServID = ' + CAST (@SRVID AS NVARCHAR (50)) +
'



';
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        PRINT @SQLStr;
        UPDATE dbo.Servers
        SET    GetVersState     = ERROR_NUMBER(),
               GetVersStateDesc = ERROR_MESSAGE()
        WHERE  ServID = @SRVID;
        EXECUTE dbo.WriteErrorLog 1, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
END

