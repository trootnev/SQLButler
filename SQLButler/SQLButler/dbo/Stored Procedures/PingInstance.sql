CREATE PROCEDURE dbo.PingInstance (@SrvID int)
AS
SET NOCOUNT ON
DECLARE @Result TABLE (PingStatus int, ErrorNumber int, ErrorMsg nvarchar(255))
DECLARE @ping INT = 1;
DECLARE @Connstr NVARCHAR (100);
DECLARE @SQLStr NVARCHAR (MAX);
DECLARE @xstate int;
DECLARE @message nvarchar(255), @error int, @trancount int


SET @Connstr = (SELECT dbo.ConnStr(ServName)
                    FROM   Servers AS s
                    WHERE  s.ServID = @SrvID
					);


IF NOT EXISTS (SELECT 1 FROM dbo.Servers WHERE ServID = @SrvID)
	BEGIN
	Set @ping = 0
	END
ELSE 
	BEGIN
	SELECT @SQLStr = '

	DECLARE @a int;
	(SELECT @a = count(*) FROM OPENROWSET(''SQLOLEDB'',' + '''' + @Connstr + '''' + ', ' + '''select @@version''' + '))
	'

	
		BEGIN TRY
		EXECUTE sp_executesql @SQLStr;
		END TRY
		BEGIN CATCH
		select @error = ERROR_NUMBER(),
               @message = ERROR_MESSAGE(), 
               @xstate = XACT_STATE();
        if @xstate = -1
            rollback ;
        if @xstate = 1 and @trancount = 0
            rollback 

		SET @Ping = 0;
		INSERT #PingStatus (PingStatus, ErrorNumber, ErrorMsg)
		VALUES (@ping,@error,@message );
				 		  
		END CATCH
	
	IF (SELECT COUNT(*) FROM #PingStatus)= 0
		INSERT #PingStatus (PingStatus)
		VALUES (1)
	
END	
	
