CREATE VIEW [dbo].[vInstanceCurrentConfiguration]
AS
SELECT  dbo.Servers.ServName,
                         dbo.InstanceConfiguration.ConfigurationID,
                         dbo.InstanceConfiguration.ConfigurationName,
                         dbo.InstanceConfiguration.ConfigurationValue,
                         dbo.InstanceConfiguration.ConfigurationMinimum,
                         dbo.InstanceConfiguration.ConfigurationMaximum,
                         dbo.InstanceConfiguration.ConfigurationDescription,
                         dbo.InstanceConfiguration.ConfigurationValueInUse,
                         dbo.InstanceConfiguration.IsDynamic,
                         dbo.InstanceConfiguration.IsAdvanced,
                         dbo.InstanceConfiguration.IsCurrent
FROM   dbo.Servers (nolock)
       INNER JOIN
       dbo.InstanceConfiguration (nolock)
       ON dbo.Servers.ServID = dbo.InstanceConfiguration.SrvID
WHERE  (dbo.InstanceConfiguration.IsCurrent = 1);

