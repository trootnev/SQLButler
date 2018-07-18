CREATE PROCEDURE [dbo].[WriteErrorLog]
@actiontype INT NULL, @actionserver INT NULL, @errorcode INT NULL, @errordesc NVARCHAR (250) NULL
AS
INSERT  INTO dbo.ManagementErrors (ActionDate, ActionType, ActionObject, ErrorCode, ErrorDesc)
VALUES                           (getdate(), @actiontype, @actionserver, @errorcode, @errordesc);

