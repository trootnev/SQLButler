CREATE TABLE [dbo].[SrvVolumes] (
    [VolumeID]          UNIQUEIDENTIFIER CONSTRAINT [DF_Table_1_DiskID] DEFAULT (newsequentialid()) NOT NULL,
    [SrvID]             INT              NOT NULL,
    [VolumeMP]          NVARCHAR (255)   NOT NULL,
    [VolumeTotalMB]     BIGINT           NULL,
    [VolumeAvailableMB] BIGINT           NULL,
    [MeasureDate]       DATETIME         CONSTRAINT [DF_SrvVolumes_MeasureDate] DEFAULT (getdate()) NULL,
    [IsCurrent]        BIT              CONSTRAINT [DF_SrvVolumes_is_current] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SrvVolumes] PRIMARY KEY CLUSTERED ([VolumeID] ASC),
    CONSTRAINT [FK_SrvVolumes_Servers] FOREIGN KEY ([SrvID]) REFERENCES [dbo].[Servers] ([ServID]) ON DELETE CASCADE
);

