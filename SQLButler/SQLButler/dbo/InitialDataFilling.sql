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
(10, 'CollectSrvSQLAdmins'),
(11,'CollectSrvVolumes')

MERGE ActionTypes AS TARGET
USING (SELECT TypeID, TypeDesc FROM @ActionTypes) as SOURCE (TypeID, TypeDesc)
ON (TARGET.TypeID = SOURCE.TypeID)
WHEN MATCHED THEN UPDATE SET TypeDesc = SOURCE.TypeDesc
WHEN NOT MATCHED THEN INSERT (TypeID,TypeDesc)
VALUES (SOURCE.TypeID, SOURCE.TypeDesc);


DECLARE @Recmodel TABLE (id int, RM nvarchar(50))

INSERT INTO @Recmodel
VALUES
(1,	'Full'),
(2,	'Bulk-Logged'),
(3,	'Simple')

Merge Recmodel as TARGET
USING (SELECT id,RM FROM @Recmodel) as SOURCE (id, RM)
ON (TARGET.id = SOURCE.id)

WHEN NOT MATCHED THEN INSERT (id,RM)
VALUES (SOURCE.id, SOURCE.RM);



DECLARE @Settings TABLE (Name nvarchar(255), IntValue int, StringValue nvarchar(255), [Description] nvarchar (255))

INSERT INTO @Settings
VALUES 
('ConfRetentionDays', 365,NULL,'How long does the collected data lives')

MERGE dbo.Settings as TARGET
USING (Select * from @Settings) as SOURCE (Name, IntValue,StringValue,Description)
ON TARGET.Name = SOURCE.Name

WHEN NOT MATCHED THEN INSERT (Name, IntValue,StringValue,Description)
VALUES (SOURCE.Name, SOURCE.IntValue, SOURCE.StringValue, SOURCE.Description);



INSERT dbo.DbVersion (Version,DateInstalled) VALUES ('0.0.2 Beta',getdate())
GO