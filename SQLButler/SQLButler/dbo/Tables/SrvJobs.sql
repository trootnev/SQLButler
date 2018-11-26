CREATE TABLE [dbo].[SrvJobs] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [SrvID]       INT            NOT NULL,
    [JobID]         NVARCHAR (150) NOT NULL,
    [JobName]    NVARCHAR (150) NOT NULL,
    [JobCategory]    NVARCHAR (150) NULL,
    [LastOutcome]  INT            NULL,
    [LastRunDate] DATE           NULL,
    [IsSystem]    BIT            NULL,
    [CatOverride] BIT            CONSTRAINT [DF_SrvJobs_CatOverride] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_SrvJobs] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_SrvJobs_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);



