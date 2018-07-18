CREATE PROCEDURE [dbo].[Perfcounter]
AS
WITH ring_buffers (ring_id, SQLProcessorUtilization)
AS   (SELECT record.value('(./Record/@id)[1]', 'int') AS record_id,
             record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization
      FROM   (SELECT CONVERT (XML, record) AS record
              FROM   sys.dm_os_ring_buffers
              WHERE  ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
                     AND record LIKE '%%') AS x)
INSERT Perfcounters
SELECT TOP 1 CURRENT_TIMESTAMP,
             ring_buffers.SQLProcessorUtilization,
             a.available_physical_memory_kb,
             pt.*
FROM   (SELECT RTRIM(object_name) + ' : ' + counter_name AS CounterName,
               cntr_value
        FROM   sys.dm_os_performance_counters
        WHERE  RTRIM(object_name) + ' : ' + counter_name IN ('SQLServer:Buffer Manager : Buffer cache hit ratio', 'SQLServer:Buffer Manager : Page life expectancy', 'SQLServer:General Statistics : User Connections', 'SQLServer:Access Methods : Full Scans/sec', 'SQLServer:Access Methods : Page Splits/sec')) AS SourceData PIVOT (SUM (cntr_value) FOR CounterName IN ([SQLServer:Buffer Manager : Buffer cache hit ratio], [SQLServer:Buffer Manager : Page life expectancy], [SQLServer:General Statistics : User Connections], [SQLServer:Access Methods : Full Scans/sec], [SQLServer:Access Methods : Page Splits/sec])) AS pt, ring_buffers, sys.dm_os_sys_memory AS a;

