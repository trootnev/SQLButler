CREATE FUNCTION [dbo].[CalcDBSize]
(@dbid INT = NULL)
RETURNS NUMERIC(18,3)
AS
BEGIN
    DECLARE @SIZEGB AS NUMERIC(18,3);
    SET @SIZEGB = (SELECT SUM(CAST(FileSize as NUMERIC(18,3))) * 8.0 / 1024.0 / 1024.0
                   FROM   DbFiles
                   WHERE  [DbID] = @dbid);
    RETURN @SIZEGB;
END

