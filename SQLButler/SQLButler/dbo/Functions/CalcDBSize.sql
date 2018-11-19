CREATE FUNCTION [dbo].[CalcDBSize]
(@dbid INT = NULL)
RETURNS FLOAT (53)
AS
BEGIN
    DECLARE @SIZEGB AS FLOAT;
    SET @SIZEGB = (SELECT SUM(size) * 8.0 / 1024 / 1024
                   FROM   DbFiles
                   WHERE  [db_id] = @dbid);
    RETURN @SIZEGB;
END

