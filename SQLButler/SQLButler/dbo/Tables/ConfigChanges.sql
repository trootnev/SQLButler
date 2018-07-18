CREATE TABLE [dbo].[ConfigChanges] (
    [RecID]                INT           IDENTITY (1, 1) NOT NULL,
    [SrvID]                INT           NOT NULL,
    [Parameter]            NVARCHAR (35) NOT NULL,
    [Change_Detected_Time] DATETIME      NOT NULL,
    [New_value]            SQL_VARIANT   NULL,
    [Value_In_Use]         SQL_VARIANT   NULL,
    [Prev_Timestamp]       DATETIME      NOT NULL,
    [Prev_Value]           SQL_VARIANT   NULL,
    [Prev_Value_in_Use]    SQL_VARIANT   NULL,
    [Approved]             BIT           CONSTRAINT [DF_ConfigChanges_Approved] DEFAULT ((0)) NOT NULL,
    [ts]                   ROWVERSION    NULL,
    CONSTRAINT [PK_ConfigChanges] PRIMARY KEY CLUSTERED ([RecID] ASC)
);

