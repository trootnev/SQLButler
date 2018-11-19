CREATE PROCEDURE [dbo].[GetDBFiles]
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DB AS NVARCHAR (200);
    DECLARE @DBID AS INT;
    DECLARE @SRVID AS INT;
    DECLARE @SQLSTR AS NVARCHAR (MAX);
    DECLARE @Connstr AS NVARCHAR (MAX);
    DECLARE @ERROR AS NVARCHAR (100);
    DECLARE @SERVNAME AS NVARCHAR (100);
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (250);
    DECLARE DB CURSOR FORWARD_ONLY READ_ONLY FAST_FORWARD
        FOR SELECT   [DBid],
                     DbName,
                     SrvID,
                     dbo.ConnStr(s.ServName),
                     s.ServName
            FROM     dbo.SrvDB AS db
                     INNER JOIN
                     dbo.Servers AS s
                     ON s.ServID = db.SrvID
            WHERE    s.active = 1
			AND s.GetVersState = 1
            ORDER BY SrvID;
    OPEN DB;
    FETCH NEXT FROM DB INTO @DBID, @DB, @SRVID, @connstr, @SERVNAME;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @ERROR_CODE = 0;
            SET @SQLSTR = '
	DECLARE @fileid int
	DECLARE @type  int
	DECLARE @size int
	DECLARE @maxsize int
	DECLARE @growth int
	DECLARE @ispctgrowth bit
	DECLARE @name nvarchar(128)
	DECLARE @filename nvarchar(max)
	
	DECLARE FILES CURSOR FORWARD_ONLY READ_ONLY FAST_FORWARD
				FOR SELECT * FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''select file_id as fileid, type, size, max_size as maxsize, growth, is_percent_growth, name, physical_name as filename from master.sys.master_files 
	where database_id =DB_ID(''''' + RTRIM(@DB) + ''''')''' + ');
	
	OPEN FILES;
	
	FETCH NEXT FROM FILES
		INTO @fileid, @type, @size, @maxsize, @growth,@ispctgrowth, @name, @filename
	WHILE @@FETCH_STATUS = 0
		BEGIN
		
		IF NOT EXISTS (SELECT 1 FROM dbo.DbFiles where db_id =' + CAST (@DBID AS NVARCHAR (50)) + ' and inner_fileid = @fileid)
			INSERT INTO dbo.DbFiles
			(
			db_id,
			inner_fileid,
			type,
			size,
			maxsize,
			growth,
			is_percent_growth,
			name,
			filename,
			MeasureDate
			)
			VALUES
			(
			' + CAST (@DBID AS NVARCHAR (50)) + ',
			@fileid,
			@type,
			@size,
			@maxsize,
			@growth,
			@ispctgrowth,
			@name,
			@filename,
			Getdate()
			)
		ELSE
			UPDATE dbo.DbFiles
			SET 
				size = @size,
				maxsize = @maxsize,
				growth = @growth,
				is_percent_growth = @ispctgrowth,
				name = @name,
				filename = @filename,
				measuredate = getdate()
			WHERE db_id = ' + CAST (@DBID AS NVARCHAR (50)) + ' 
			AND inner_fileid = @fileid
		
		FETCH NEXT FROM FILES
			INTO @fileid, @type, @size, @maxsize, @growth,@ispctgrowth, @name, @filename
	END
	CLOSE FILES;
	DEALLOCATE FILES
	';
            BEGIN TRY
                EXECUTE sp_executesql @SQLSTR;
            END TRY
            BEGIN CATCH
                SET @ERROR_CODE = ERROR_NUMBER();
                SET @ERROR_MESS = ERROR_MESSAGE();
                EXECUTE dbo.WriteErrorLog 3, @SRVID, @ERROR_CODE, @ERROR_MESS;
                UPDATE DBO.Servers
                SET    GetDbFilesState     = @ERROR_CODE,
                       GetDbFilesStateDesc = @ERROR_MESS
                WHERE  ServID = @SRVID;
            END CATCH
            IF @ERROR_CODE = 0
                UPDATE dbo.Servers
                SET    GetDbFilesState     = 1,
                       GetDbFilesStateDesc = 'Success'
                WHERE  ServID = @SRVID;
            FETCH NEXT FROM DB INTO @DBID, @DB, @SRVID, @connstr, @SERVNAME;
        END
    CLOSE DB;
    DEALLOCATE DB;
END

