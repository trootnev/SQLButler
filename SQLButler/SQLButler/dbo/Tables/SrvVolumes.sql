CREATE TABLE [dbo].[SrvVolumes] (
    [VolumeId]          UNIQUEIDENTIFIER CONSTRAINT [DF_Table_1_DiskId] DEFAULT (newsequentialid()) NOT NULL,
    [SrvId]             INT              NOT NULL,
    [VolumeMP]          NVARCHAR (255)   NOT NULL,
    [VolumeTotalMB]     BIGINT           NULL,
    [VolumeAvailableMB] BIGINT           NULL,
    [MeasureDate]       DATETIME         CONSTRAINT [DF_SrvVolumes_MeasureDate] DEFAULT (getdate()) NULL,
    [IsCurrent]        BIT              CONSTRAINT [DF_SrvVolumes_is_current] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SrvVolumes] PRIMARY KEY CLUSTERED ([VolumeId] ASC),
    CONSTRAINT [FK_SrvVolumes_Servers] FOREIGN KEY ([SrvId]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);

