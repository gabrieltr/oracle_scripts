
SELECT * FROM V$DATABASE_BLOCK_CORRUPTION order by 1,2;

SELECT distinct file# FROM V$DATABASE_BLOCK_CORRUPTION;

RECOVER CORRUPTION LIST;

BACKUP CHECK LOGICAL VALIDATE DATABASE;

select * from dba_extents where file_id=P1 and P2 between block_id and block_id + blocks - 1;
P1 - file
P2 - block


alter system set db_lost_write_protect=typical scope=both;
alter system set db_block_checking=full scope=both;
alter system set db_block_checksum=full scope=both;


select * from dba_extents where file_id=67 and 3235376 between block_id and block_id + blocks - 1;

RUN
{
  ALLOCATE CHANNEL c01 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c02 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c03 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c04 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c05 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c06 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c07 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c08 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c09 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c10 DEVICE TYPE DISK;

  RESTORE DATABASE;
  RECOVER DATABASE;

  BACKUP VALIDATE 
  CHECK LOGICAL 
  DATABASE 
  ARCHIVELOG ALL;
}

RUN
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c4 DEVICE TYPE DISK;
  
  VALIDATE database SECTION SIZE 1200M;
}

RUN
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c4 DEVICE TYPE DISK;
  BACKUP CHECK LOGICAL VALIDATE DATABASE SECTION SIZE 1200M;;
}

RUN
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c4 DEVICE TYPE DISK;
  backup as copy datafile;
}

RUN
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK;
  restore datafile 29 from TAG TAG20180315T095609;
  RECOVER DATAFILE 29 from TAG TAG20180315T095609;
}
  validate backupset 1432 SECTION SIZE 1200M;
  FROM ACTIVE DATABASE

select count(*), file#
FROM V$DATABASE_BLOCK_CORRUPTION b
group by cube(file#)
order by 2;


SELECT b.file#, b.block#, e.OWNER, e.SEGMENT_NAME, e.SEGMENT_TYPE
FROM V$DATABASE_BLOCK_CORRUPTION b
join dba_extents e on e.file_id=b.file#
 and b.block# between e.block_id and e.block_id + e.blocks - 1;
;

ALTER TABLESPACE SYSAUX FORCE LOGGING;       
ALTER TABLESPACE PSAPUNDO FORCE LOGGING;     
ALTER TABLESPACE PSAPTEMP FORCE LOGGING;     
ALTER TABLESPACE PSAPSR3 FORCE LOGGING;      
ALTER TABLESPACE PSAPSR3701 FORCE LOGGING;   
ALTER TABLESPACE PSAPSR3USR FORCE LOGGING; 


ALTER DATABASE ENABLE BLOCK CHANGE TRACKING;
ALTER DATABASE ENABLE BLOCK CHANGE TRACKING using file '/oracle/PIP/sapdata/changetracking/pip_blockchangetracking.chg';
select * from v$block_change_tracking;
