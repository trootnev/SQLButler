CREATE FUNCTION [dbo].[CalcDBSize]
(@dbid INT = NULL)
RETURNS FLOAT (53)
AS
BEGIN
    DECLARE @SIZEGB AS FLOAT;
    SET @SIZEGB = (SELECT SUM(FileSize) * 8.0 / 1024 / 1024
                   FROM   DbFiles
                   WHERE  [DbId] = @dbid);
    RETURN @SIZEGB;
END

