show parameter db_recovery_file_dest

set lines 300
col name for a32
col size_m for 999,999,999
col used_m for 999,999,999
col pct_used for 999.99

SELECT name
, ceil( space_limit / 1024 / 1024) SIZE_M
, ceil( space_used  / 1024 / 1024) USED_M
, ceil( space_reclaimable  / 1024 / 1024) RECLAIMABLE_M
, decode( nvl( space_used, 0), 0, 0
  , round ( ( ( space_used - space_reclaimable ) / space_limit) * 100, 2) ) PCT_USED
 FROM v$recovery_file_dest
ORDER BY name
/
