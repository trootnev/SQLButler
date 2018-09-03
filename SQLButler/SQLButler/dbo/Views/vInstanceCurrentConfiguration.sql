CREATE VIEW [dbo].[vInstanceCurrentConfiguration]
AS
SELECT TOP (100) PERCENT dbo.Servers.ServName,
                         dbo.InstanceConfiguration.configuration_id,
                         dbo.InstanceConfiguration.name,
                         dbo.InstanceConfiguration.value,
                         dbo.InstanceConfiguration.minimum,
                         dbo.InstanceConfiguration.maximum,
                         dbo.InstanceConfiguration.description,
                         dbo.InstanceConfiguration.value_in_use,
                         dbo.InstanceConfiguration.is_dynamic,
                         dbo.InstanceConfiguration.is_advanced,
                         dbo.InstanceConfiguration.is_current
FROM   dbo.Servers (nolock)
       INNER JOIN
       dbo.InstanceConfiguration (nolock)
       ON dbo.Servers.ServID = dbo.InstanceConfiguration.SrvID
WHERE  (dbo.InstanceConfiguration.is_current = 1);

