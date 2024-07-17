-- List the queries running on SQL Server
SELECT
    p.spid, p.status, p.hostname, p.loginame, p.cpu, r.start_time, r.command,
    p.program_name, text 
FROM
    sys.dm_exec_requests AS r,
    master.dbo.sysprocesses AS p 
    CROSS APPLY sys.dm_exec_sql_text(p.sql_handle)
WHERE
    p.status NOT IN ('sleeping', 'background') 
AND r.session_id = p.spid
--order by cpu desc
order by start_time asc


--kill 1226