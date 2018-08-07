
CREATE VIEW vInstanceProperties
AS
SELECT ip.PropertyID, s.ServName,ipt.PropertyTypeName,ip.PropertyStringValue,ip.PropertyNumericValue,ip.PropertyIntValue
 FROM dbo.InstanceProperties ip
JOIN dbo.Servers s on ip.SrvID = s.ServID
JOIN dbo.InstancePropertyTypes ipt on ipt.PropertyTypeID = ip.PropertyTypeID