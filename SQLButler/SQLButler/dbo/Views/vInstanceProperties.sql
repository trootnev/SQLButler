
CREATE VIEW [dbo].[vInstanceProperties]
AS
SELECT        ip.PropertyID,ip.SrvID, s.ServName, ipt.PropertyTypeName, ip.PropertyStringValue, ip.PropertyNumericValue, ip.PropertyIntValue
FROM            dbo.InstanceProperties (nolock) AS ip INNER JOIN
                         dbo.Servers (nolock) AS s ON ip.SrvID = s.ServID INNER JOIN
                         dbo.InstancePropertyTypes (nolock) AS ipt ON ipt.PropertyTypeID = ip.PropertyTypeID
WHERE        (ip.IsCurrent = 1)
GO

