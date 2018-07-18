CREATE TABLE [dbo].[Cluster] (
    [Clusterid]   INT            IDENTITY (1, 1) NOT NULL,
    [ClusterName] NVARCHAR (50)  NOT NULL,
    [OS]          NVARCHAR (100) NULL,
    [ClusterIP]   NVARCHAR (100) NULL,
    CONSTRAINT [PK_Cluster] PRIMARY KEY CLUSTERED ([Clusterid] ASC)
);

