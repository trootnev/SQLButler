CREATE VIEW [dbo].[vLoginTypes]
AS
SELECT [LoginTypeID],
       [LoginTypeName],
       [LoginTypeDesc]
FROM   [dbo].[LoginTypes] (nolock);

