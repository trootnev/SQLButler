CREATE TABLE [dbo].[SrvRoleMembers](
	[RecID] [uniqueidentifier] NOT NULL,
	[SrvID] [bigint] NOT NULL,
	[batch_id] [uniqueidentifier] NOT NULL,
	[CollectionDate] [datetime] NOT NULL,
	[RoleType] [varchar](50) NOT NULL,
	[Role] [sysname] NOT NULL,
	[Member] [sysname] NOT NULL,
	[Login] [sysname] NOT NULL,
	[SID] [varbinary](85) NULL,
 CONSTRAINT [PK_SrvRoleMembers_1] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SrvRoleMembers] ADD  CONSTRAINT [DF_SrvRoleMembers_RecID]  DEFAULT (newsequentialid()) FOR [RecID]
GO
