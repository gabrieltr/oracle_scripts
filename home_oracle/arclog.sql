﻿set linesize 400
set pagesize 9999

archive log list;
ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';
SELECT SEQUENCE#, FIRST_TIME, NEXT_TIME FROM V$ARCHIVED_LOG ORDER BY SEQUENCE#;
