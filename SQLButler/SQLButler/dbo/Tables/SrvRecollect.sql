CREATE TABLE [dbo].[SrvRecollect] (
    [SrvID] INT NULL
);


GO
CREATE TRIGGER [dbo].[tSrvRecollect]
    ON [dbo].[SrvRecollect]
    INSTEAD OF INSERT
    AS BEGIN
           SET NOCOUNT ON;
           DECLARE @SID AS INT;
           SELECT @SID = SrvID
           FROM   inserted;
           EXECUTE dbo.CollectSrvData @SRV = @SID;
       END

