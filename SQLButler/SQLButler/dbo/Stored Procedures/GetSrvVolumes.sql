CREATE PROCEDURE [dbo].[GetSrvVolumes]
@SRVID INT NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Connstr AS NVARCHAR (100);
    DECLARE @SQLStr AS NVARCHAR (MAX);
    DECLARE @ACTIONTYPE AS INT;
    SET @ACTIONTYPE = 11;
    DECLARE @ERROR_CODE AS INT;
    DECLARE @ERROR_MESS AS NVARCHAR (400);
    SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers AS s
                    WHERE  s.ServID = @SRVID
					);
    SET @SQLStr = '
	SET NOCOUNT ON;
	
	DECLARE @SrvID int = '+CAST(@SRVID as nvarchar(10))+'
	DECLARE @result TABLE (Volume nvarchar(255),TotalMB bigint, AvailableMB bigint)
	Insert @result
	SELECT Volume,TotalMB,AvailableMB FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''
	SET NOCOUNT ON;

	DECLARE @result TABLE (Volume nvarchar(255),TotalMB bigint, AvailableMB bigint)

	IF (@@MicrosoftVersion/0x01000000)<11
		BEGIN
			INSERT @result (Volume, AvailableMB)
			EXEC(''''xp_fixeddrives'''')

		END

		ELSE
			BEGIN
			INSERT @result(Volume, TotalMB,AvailableMB)
			select distinct 
			vs.volume_mount_point,
			--vs.logical_volume_name,
			total_bytes/1048576.0 as TotalMb ,
			vs.available_bytes/1048576.0 as AvailableMb 
				from
				sys.master_files ms outer apply
				 sys.dm_os_volume_stats(ms.database_id,file_id) vs
				 where volume_mount_point is not null
			END

	SELECT Volume, TotalMB,AvailableMB FROM @result


''' + ')
	UPDATE dbo.SrvVolumes
	SET IsCurrent =0 
	WHERE SrvID = @SrvID
	AND IsCurrent = 1


	INSERT dbo.SrvVolumes (SrvID,VolumeMP,VolumeTotalMB,VolumeAvailableMB,IsCurrent )
	SELECT @SrvID,
			Volume,
			TotalMB,
			AvailableMB,
			1
	FROM @result r
'
    BEGIN TRY
        --PRINT @sqlstr
		EXECUTE sp_executesql @SQLStr;
    END TRY
    BEGIN CATCH
        SET @ERROR_CODE = ERROR_NUMBER();
        SET @ERROR_MESS = ERROR_MESSAGE();
        --PRINT @SQLStr;
        EXECUTE dbo.WriteErrorLog 11, @SRVID, @ERROR_CODE, @ERROR_MESS;
    END CATCH
END