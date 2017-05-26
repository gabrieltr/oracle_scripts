﻿set linesize 999
SET PAGESIZE  9999

col "type" for a7
col member for a42
col dest_name for a30
col DESTINATION for a40

select * from v$logfile
order by group#, member
/

SELECT dest_name, status, destination FROM v$archive_dest
where status != 'INACTIVE';

archive log list;

SELECT GROUP#, ARCHIVED, STATUS FROM V$LOG
order by 1
/