CREATE PROCEDURE [dbo].[GetDBNames]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQLSTR AS NVARCHAR (MAX);
    DECLARE @Connstr AS NVARCHAR (MAX);
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (250);
    SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers
                    WHERE  ServID = @SRVID);
    SET @SQLSTR = '
DECLARE @DB NVARCHAR(50)
DECLARE @RM TINYINT
DECLARE @Owner NVARCHAR(50)
DECLARE DBNAME CURSOR
		FOR
		SELECT * FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''select db.name,db.recovery_model,  sl.name as OwnerLogin

 from sys.databases db

 join sys.server_principals sl on db.owner_sid = sl.sid''' + ');
OPEN DBNAME;
FETCH NEXT FROM DBNAME
INTO @DB, @RM,@Owner
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (SELECT DbName FROM dbo.SrvDB WHERE SrvID =' + CAST (@SRVID AS NVARCHAR (10)) + ' AND DbName = @DB )
	BEGIN
	Insert into dbo.SrvDB
	(SrvID,
	DbName,
	RecMod,
	OwnerLogin)
	VALUES (' + CAST (@SRVID AS NVARCHAR (10)) + ', @DB,@RM,@Owner)
	END
	
	UPDATE SrvDB
	SET RecMod = @RM,
	OwnerLogin = @Owner
	where Srvid = ' + CAST (@SRVID AS NVARCHAR (10)) + '
	AND DBNAME = @DB
	--AND (RecMod <> @RM OR OwnerLogin <> @Owner)
	
	UPDATE dbo.Servers
	Set GetDBState = 1,
	GetDBStateDesc = ''Success''
	WHERE ServID =  ' + CAST (@SRVID AS NVARCHAR (10)) + '	
FETCH NEXT FROM DBNAME
INTO @DB, @RM, @Owner
END
CLOSE DBNAME;
DEALLOCATE DBNAME
';
    BEGIN TRY
        EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        UPDATE dbo.Servers
        SET    GetDBState     = ERROR_NUMBER(),
               GetDBStateDesc = ERROR_MESSAGE()
        WHERE  ServID = @SRVID;
        EXECUTE dbo.WriteErrorLog 2, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
END

