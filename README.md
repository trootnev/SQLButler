# SQLButler
SQL Server inventory system for easy use

System is a database with Access as a client application (yes, I know, but nothing better I can do myself)
System uses OPENROWSET to connect to server in the inventory and collect various information:
* SQL Server configuration, including change detection (comparing new and previous parameter values)
* SQL Server Version
* Databases list and their files information
* Jobs (including recent outcome)
* Logins
* Server Roles and members
* MSDB role members

