/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
DECLARE @ActionTypes TABLE (TypeID int,TypeDesc nvarchar(255))

INSERT INTO @ActionTypes (TypeID,TypeDesc)
VALUES (1, 'GetSrvVers'),
(2, 'SrvGetDBNames'),
(3, 'GetDBFiles'),
(4, 'GetJobsInfo'),
(5,'GetJobsCategory'),
(6, 'GetSrvProperties'),
(7, 'GetSrvConfiguration'),
(8, 'CheckSrvLogins'),
(9, 'CollectLogins'),
(10, 'CollectSrvSQLAdmins')

MERGE ActionTypes AS TARGET
USING (SELECT TypeID, TypeDesc FROM @ActionTypes) as SOURCE (TypeID, TypeDesc)
ON (TARGET.TypeID = SOURCE.TypeID)
WHEN MATCHED THEN UPDATE SET TypeDesc = SOURCE.TypeDesc
WHEN NOT MATCHED THEN INSERT (TypeID,TypeDesc)
VALUES (SOURCE.TypeID, SOURCE.TypeDesc);
