CREATE TABLE [dbo].[ClusterNodes] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [ClusterId]    INT            NOT NULL,
    [NodeName]   NVARCHAR (100) NOT NULL,
    [NodeStatus] INT            NOT NULL,
    CONSTRAINT [PK_ClusterNodes] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ClusterNodes_Cluster] FOREIGN KEY ([ClusterId]) REFERENCES [dbo].[Cluster] ([Clusterid])
);

