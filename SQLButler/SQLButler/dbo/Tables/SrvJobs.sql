CREATE TABLE [dbo].[SrvJobs] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [srvid]       INT            NOT NULL,
    [jid]         NVARCHAR (150) NOT NULL,
    [job_name]    NVARCHAR (150) NOT NULL,
    [category]    NVARCHAR (150) NULL,
    [lastresult]  INT            NULL,
    [lastrundate] DATE           NULL,
    [IsSystem]    BIT            NULL,
    [CatOverride] BIT            CONSTRAINT [DF_SrvJobs_CatOverride] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_SrvJobs] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_SrvJobs_Servers] FOREIGN KEY ([srvid]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);



