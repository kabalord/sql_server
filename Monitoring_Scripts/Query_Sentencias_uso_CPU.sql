SELECT TOP 25
CONVERT(varchar,qs.last_execution_time,120),
    qs.sql_handle,
    qs.execution_count,
    qs.total_worker_time AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
        qs.total_worker_time/1000000,
    average_CPU_inSeconds = --Converted from microseconds
        (qs.total_worker_time/1000000) / qs.execution_count,
    qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
        qs.total_elapsed_time/1000000,
    st.text,
    qp.query_plan
FROM
   sys.dm_exec_query_stats AS qs
CROSS APPLY 
    sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY
    sys.dm_exec_query_plan (qs.plan_handle) AS qp
	where CONVERT(varchar,qs.last_execution_time,120) between '2021-11-01 00:00' and '2021-11-30 04:00'
ORDER BY 
    qs.total_worker_time DESC


SELECT TOP 25
    qs.sql_handle,
	count (*) as Apariciones,
    SUM(qs.execution_count) As Count_exec,
    SUM(qs.total_worker_time) AS Total_CPU,
    st.text
FROM
   sys.dm_exec_query_stats AS qs
CROSS APPLY 
    sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY
    sys.dm_exec_query_plan (qs.plan_handle) AS qp
	where CONVERT(varchar,qs.last_execution_time,120) between '2021-11-01 15:00' and '2021-11-30 04:00'
group by qs.sql_handle,st.text
ORDER BY SUM(qs.total_worker_time) DESC