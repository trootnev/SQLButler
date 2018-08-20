CREATE PROCEDURE dbo.PingInstance (@SrvID int,
@result int OUTPUT

)
AS
SET NOCOUNT ON
DECLARE @ping INT = 1;
DECLARE @Connstr NVARCHAR (100);
DECLARE @SQLStr NVARCHAR (MAX);


IF NOT EXISTS (SELECT 1 FROM dbo.Servers WHERE ServID = @SrvID)
	BEGIN
	Set @ping = 0
	END
ELSE 
	BEGIN
	SELECT @SQLStr = '

	DECLARE @a int;
	(SELECT @a = count(*) FROM OPENROWSET(''SQLNCLI'',' + '''' + connstr + '''' + ', ' + '''select @@version''' + '))
	'
	FROM dbo.Servers
	WHERE ServID = @SrviD

		BEGIN TRY
		EXECUTE sp_executesql @SQLStr;
		END TRY
		BEGIN CATCH
		--SELECT ERROR_NUMBER(),ERROR_MESSAGE(),@SQLStr
		 		  SET @Ping = 0;
		END CATCH
END	
	
Set @result = @ping