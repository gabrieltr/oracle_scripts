﻿https://dbatricksworld.com/steps-to-configure-oracle-11g-data-guard-physical-standby-data-guard-part-i/
solman: 8000028170

## restart ssh
lssrc -s sshd 
stopsrc -s sshd;startsrc -s sshd

#
find /oracle/ | grep trace.listener.log

kill `ps -ef | grep -i tail | grep -v grep | awk '{print $2}' `

for die1 in `ps -ef | grep -i tail | grep -v grep | awk '{print $2}' `
do 
kill ${die1}
done
find /oracle/$ORACLE_SID -name listener.log -exec tail -f {]\;
for lsnr in `find /oracle/$ORACLE_SID -name listener.log`
do
  tail -f ${lsnr}&
done


-- cria pfile no $ORACLE_HOME/dbs/initXXXX.ora  XXXX = SID = eq0
create pfile from spfile;
-- abrir initeq0.ora para trocar/adicionar db_unique_name='eq0A'

--configura 
ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(eq0A,eq0B)';


-- Enable Forced Logging

ALTER DATABASE FORCE LOGGING;
 Configure the Primary Database to Receive Redo Data****

-- Set Primary Database Initialization Parameters

DB_NAME=eq0
DB_UNIQUE_NAME=eq0
LOG_ARCHIVE_CONFIG='DG_CONFIG=(eq0A,eq0B)'
CONTROL_FILES='/arch1/eq0/control1.ctl', '/arch2/eq0/control2.ctl'
LOG_ARCHIVE_DEST_1='LOCATION=/arch1/eq0/ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=eq0A'
LOG_ARCHIVE_DEST_2='SERVICE=eq0 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=eq0B'
LOG_ARCHIVE_DEST_STATE_1=ENABLE
LOG_ARCHIVE_DEST_STATE_2=ENABLE
REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE
LOG_ARCHIVE_FORMAT=%t_%s_%r.arc

eq0A
ALTER SYSTEM SET log_archive_config='DG_CONFIG=(EQ0A,EQ0B)' scope=both;
ALTER SYSTEM SET log_archive_dest_1='LOCATION=+ARCH/eq0/oraarch VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=eq0A' scope=both;
ALTER SYSTEM SET log_archive_dest_2='SERVICE=eq0B ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=eq0B' scope=both;

eq0B
ALTER SYSTEM SET log_archive_config='DG_CONFIG=(eq0A,eq0B)' scope=both;
ALTER SYSTEM SET log_archive_dest_1='LOCATION=+ARCH/eq0/oraarch VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=eq0B' scope=both;
ALTER SYSTEM SET log_archive_dest_2='SERVICE=EQ0A ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=EQ0A' scope=both;

ALTER SYSTEM SET log_archive_dest_2='SERVICE=EQ0B ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=EQ0B' scope=both;

ALTER SYSTEM SET log_archive_dest_state_2=reset;


alter system set STANDBY_FILE_MANAGEMENT='AUTO'  scope=both;

alter system set FAL_SERVER='eq0A'  scope=both;
alter system set FAL_SERVER='eq0B'  scope=both;

alter system set FAL_CLIENT='EQ0B'  scope=both;

--Primary Database: Standby Role Initialization Parameters  
FAL_SERVER=boston
DB_FILE_NAME_CONVERT='boston','chicago'
LOG_FILE_NAME_CONVERT=
 '/arch1/boston/','/arch1/chicago/','/arch2/boston/','/arch2/chicago/' 
STANDBY_FILE_MANAGEMENT=AUTO

### RESTART 
shutdown immediate

# inicia usando 
startup pfile="/oracle/eq0/11204/dbs/initeq0.ora";
startup pfile="/oracle/eq0/11204/dbs/initeq0B.ora";


# cria um control file para subir instancia do standby
alter database create standby controlfile as '/migracao/backup/standbyctrl.ctl';
create pfile='/migracao/backup/initeq0B.ora' from spfile;
create pfile='/home/oracle/initeq0B.ora' from spfile;

#criar arquivo de senha
orapwd file=$ORACLE_HOME/dbs/orapwEQ0 password=DRSAP01EQ0 entries=20 force=y format=12

select * from v$pwfile_users;
col username for a15
select USERNAME, SYSDBA, SYSOPER, SYSASM, SYSBACKUP, SYSDG, SYSKM, ACCOUNT_STATUS from v$pwfile_users;


orapwd file=$ORACLE_HOME/dbs/orapwEQ0 password=DRSAP01EP0 force=y format=12

orapwd file=$ORACLE_HOME/dbs/orapwED0 password=DRSAP01ED0 force=y format=12
orapwd file=$ORACLE_HOME/dbs/orapwEQ0 password=DRSAP01EQ0 force=y ignorecase=Y format=12


scp $ORACLE_HOME/dbs/orapw* oracle@sapqa1:$ORACLE_HOME/dbs/
chown oracle:oinstall /oracle/eq0/11204/dbs/orapwdED0

sqlplus SYS/DRSAP01EQ0@EQ0A as sysdba

conn SYS/DRSAP01EQ0@EQ0A as sysdba
conn SYSTEM/DRSAP01EQ0@EQ0A as sysdba

'/oracle/eq0/11204/dbs/stdby.ctl'
*.control_files='+DATA/eq0/cntrleq0.ctl','+ARCH/eq0/cntrleq0.ctl'

alter database copy controlfile to '+DATA/eq0/controlfileeq0.ctl';

alter system set control_files='+DATA/eq0/controlfileeq0.ctl','+ARCH/eq0/controlfileeq0.ctl' scope=both sid='*';


PAUSE on STEP 14;


create user sum identified by sum123;
grant dba to sum;

restore controlfile to '+arch' from '/migracao/initeq0B.ora';

/migracao/standbyctrl.ctl
/migracao/initeq0B.ora

/oracle/eq0/11204/dbs/stdby.ctl

*.control_files='+DATA/eq0/cntrleq0.dbf','+ARCH/eq0/cntrleq0.dbf'


startup pfile="/oracle/eq0/11204/dbs/initeq0.ora" nomount;
show parameter control

--Start the database:
STARTUP NOMOUNT;

--Mount the standby database:
ALTER DATABASE MOUNT STANDBY DATABASE;

--Start the managed recovery operation:
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;


scp orapwdED0 root@sapdev2:/oracle/eq011204/dbs/
chown oracle:oinstall /oracle/eq011204/dbs/orapwdED0


alter database backup controlfile to trace as '/migracao/ctrlfilea.txt';
alter database backup controlfile to trace as '/migracao/ctrlfilea.txt';


sqlplus sys/DRSAP01Eq0@eq0A as sysdba
sqlplus sys/DRSAP01Eq0@eq0B as sysdba

STARTUP NOMOUNT

sqlplus sys/DRSAP01Eq0@eq0B as sysdba

rman target sys/DRSAP01Eq0@eq0A nocatalog
connect target sys/DRSAP01Eq0@eq0A
connect auxiliary /

STARTUP CLONE NOMOUNT FORCE;
DUPLICATE TARGET DATABASE TO AUX;

 lsnrctl stop; lsnrctl start;sleep 5;
 lsnrctl status


sqlplus SYS/DRSAP01Eq0@eq0 as sysdba
sqlplus SYS/DRSAP01Eq0@eq0A as sysdba 
sqlplus SYS/DRSAP01Eq0@eq0B as sysdba 

shutdown immediate;

startup nomount;

rman TARGET SYS/DRSAP01Eq0@eq0A AUXILIARY SYS/DRSAP01Eq0@eq0B

CONNECT AUXILIARY SYS/DRSAP01Eq0@eq0
CONNECT AUXILIARY SYS/DRSAP01Eq0@eq0B
CONNECT TARGET SYS/DRSAP01Eq0@eq0A

rman TARGET SYS/DRSAP01EQ0@EQ0B AUXILIARY SYS/DRSAP01EQ0@EQ0A

rman TARGET SYS/DRSAP01EQ0@EQ0A AUXILIARY SYS/DRSAP01EQ0@EQ0B
rman TARGET SYS/DRSAP01ED0@ED0A AUXILIARY / SYS/DRSAP01ED0@ED0B

rman TARGET SYS/DRSAP01EP0@EP0A AUXILIARY SYS/DRSAP01EP0@EP0B
run{
ALLOCATE AUXILIARY CHANNEL cb1 DEVICE TYPE DISK;
ALLOCATE CHANNEL ca1 DEVICE TYPE DISK;
ALLOCATE AUXILIARY CHANNEL cb2 DEVICE TYPE DISK;
ALLOCATE CHANNEL ca2 DEVICE TYPE DISK;
DUPLICATE TARGET DATABASE
  FOR STANDBY
  FROM ACTIVE DATABASE 
  DORECOVER
  NOFILENAMECHECK;
}



duplicate target database from active database using COMPRESSED BACKUPSET;


restore database;
recover database;


alter system set LOCAL_LISTENER='(ADDRESS = (PROTOCOL = TCP)(HOST = sapdev2)(PORT = 1522))' scope=both;


###
criar no eq0 B os mesmos logfiles


ALTER DATABASE CLEAR LOGFILE GROUP 3;
ALTER DATABASE DROP  LOGFILE GROUP 3;
ALTER DATABASE ADD   LOGFILE thread 1 group 1 ('+ARCH', '+DATA') SIZE 400M reuse;

ALTER DATABASE ADD   LOGFILE thread 1 group 1 ('+ARCH', '+DATA') SIZE 400M reuse;
ALTER DATABASE ADD   LOGFILE thread 1 group 2 ('+ARCH', '+DATA') SIZE 400M reuse;
ALTER DATABASE ADD   LOGFILE thread 1 group 3 ('+ARCH', '+DATA') SIZE 400M reuse;
ALTER DATABASE ADD   LOGFILE thread 1 group 4 ('+ARCH', '+DATA') SIZE 400M reuse;

ALTER DATABASE CLEAR LOGFILE GROUP 3;
ALTER DATABASE DROP  LOGFILE GROUP 3;
ALTER DATABASE ADD   LOGFILE thread 1 group 3 ('+ARCH', '+DATA') SIZE 1000M reuse;

select group#,thread#,sequence#,bytes,used,status from v$standby_log;

alter database flashback off;
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=MANUAL;

ALTER DATABASE CLEAR LOGFILE GROUP 5;
ALTER DATABASE DROP  LOGFILE GROUP 5;
alter database add STANDBY LOGFILE thread 1 GROUP 2 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
ALTER DATABASE CLEAR LOGFILE GROUP 6;
ALTER DATABASE DROP  LOGFILE GROUP 6;
alter database add LOGFILE thread 1 GROUP 6 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add LOGFILE thread 1 GROUP 7 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add LOGFILE thread 1 GROUP 8 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add LOGFILE thread 1 GROUP 9 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
ALTER DATABASE DROP LOGFILE GROUP 7;
ALTER DATABASE DROP LOGFILE GROUP 8;
ALTER DATABASE DROP LOGFILE GROUP 9;

ALTER DATABASE CLEAR LOGFILE GROUP 11;
ALTER DATABASE DROP  LOGFILE GROUP 11;
ALTER DATABASE DROP  LOGFILE GROUP 12;
ALTER DATABASE DROP  LOGFILE GROUP 13;
ALTER DATABASE DROP  LOGFILE GROUP 14;
ALTER DATABASE DROP  LOGFILE GROUP 15;
ALTER DATABASE DROP  LOGFILE GROUP 16;
ALTER DATABASE DROP  LOGFILE GROUP 17;
alter database add STANDBY LOGFILE thread 1 GROUP 11 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE thread 1 GROUP 12 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE thread 1 GROUP 13 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE thread 1 GROUP 14 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE thread 1 GROUP 15 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE thread 1 GROUP 16 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE thread 1 GROUP 17 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE GROUP 16 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;
alter database add STANDBY LOGFILE GROUP 17 ('+DATA', '+ARCH') SIZE 400M BLOCKSIZE 512 reuse;

ALTER DATABASE DROP LOGFILE GROUP 16;
ALTER DATABASE DROP LOGFILE GROUP 17;
alter database add standby logfile thread 1 group 7 size

EDIT DATABASE ep0b SET STATE = APPLY-OFF;
EDIT DATABASE ep0b SET STATE = APPLY-ON;

alter system switch logfile;
@logfile

show parameters STANDBY
alter database flashback on;
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO scope=both;

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE NODELAY DISCONNECT FROM SESSION;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT;

ALTER SYSTEM SET db_recovery_file_dest='';

@eq0A:

SET LINESIZE  160
SET PAGESIZE  9999
col "type" for a7
col member for a42
select * from v$logfile order by 1,4;
SELECT GROUP#, ARCHIVED, STATUS FROM V$LOG;

ALTER DATABASE DROP LOGFILE GROUP &groupNum;
ALTER DATABASE DROP LOGFILE GROUP 2;
ALTER DATABASE DROP LOGFILE GROUP 3;
ALTER DATABASE DROP LOGFILE GROUP 4;
ALTER DATABASE DROP LOGFILE GROUP 5;
ALTER DATABASE DROP LOGFILE GROUP 6;

ALTER DATABASE ADD LOGFILE GROUP 11 ('+ARCH/eq0/onlinelog/online11.dbf') size 200M REUSE;
ALTER DATABASE ADD LOGFILE GROUP 12 ('+ARCH/eq0/onlinelog/online12.dbf') size 200M REUSE;
ALTER DATABASE DROP LOGFILE GROUP 10;
ALTER DATABASE DROP LOGFILE GROUP 12;


ALTER DATABASE DROP LOGFILE MEMBER '+RECO';

ALTER DATABASE CLEAR LOGFILE GROUP 10;
ALTER DATABASE CLEAR LOGFILE GROUP 2;
ALTER DATABASE CLEAR LOGFILE GROUP 3;
ALTER DATABASE CLEAR LOGFILE GROUP 4;
ALTER DATABASE CLEAR LOGFILE GROUP 5;
ALTER DATABASE CLEAR LOGFILE GROUP 6;



run {
   set until scn  31494273;
   recover standby clone database
    delete archivelog;
}

run {
   recover
   standby
   clone database
    delete archivelog;
}


archive log list;
ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';
SELECT SEQUENCE#, FIRST_TIME, NEXT_TIME, STANDBY_DEST, ARCHIVED, APPLIED, DELETED, STATUS FROM V$ARCHIVED_LOG ORDER BY SEQUENCE#;

ALTER SYSTEM SWITCH LOGFILE;

alter system checkpoint;

alter system archive log current;

set linesize 999
col dest_name for a30
col DESTINATION for a40
SELECT dest_name, status, destination FROM v$archive_dest
where status != 'INACTIVE';

ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=enable;

!cat /oracle/eq0/saptrace/diag/rdbms/eq0b/eq0/trace/alert*

-- to see database is standby or primary role
col DB_UNIQUE_NAME for a15
SELECT DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE FROM v$database;

-- if is "PRIMARY"
ALTER DATABASE CONVERT TO PHYSICAL STANDBY;

shutdown immediate;
STARTUP MOUNT;

SELECT database_role FROM v$database;

-- after that, it should be: PHYSICAL STANDBY

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

col name for a45
select file#, status, enabled, name from v$datafile;

alter database flashback OFF;

-- Shutdown database
SHUTDOWN IMMEDIATE;
-- Start database again with Mount option
STARTUP MOUNT
-- Change database to Noarchivelog mode 
--ALTER DATABASE NOARCHIVELOG;
ALTER DATABASE ARCHIVELOG;
-- Open database
ALTER DATABASE OPEN ;

alter database flashback ON;

rman TARGET sys/DRSAP01ED0@ED0a auxiliary sys/DRSAP01EQ0@ED0
rman TARGET sys/DRSAP01EQ0@eq0a auxiliary sys/DRSAP01EQ0@eq0
rman TARGET sys/DRSAP01EP0@ep0a auxiliary sys/DRSAP01EP0@ep0b

rman TARGET  /
sql "alter system enable restricted session";
drop database including backups;
sql "alter system disable restricted session";


---------------------- dg
show DATABASE verbose eq0a;

edit database ed0a set property RedoCompression=ENABLE;
edit database ed0b set property RedoCompression=ENABLE;

alter system set log_archive_dest_state_2=DEFER scope=both;
alter system set log_archive_dest_state_2=ENABLE scope=both;
show parameter cpu
alter system set cpu_count=8 scope=both;
conn sys/DRSAP01EQ0@eq0a as sysdba
@status

SELECT to_char(TIMESTAMP, 'dd/mm/yy hh24:mi:ss') as TIMESTAMP, MESSAGE FROM V$DATAGUARD_STATUS
order by MESSAGE_NUM;

ALTER SYSTEM SET log_archive_start=true SCOPE=spfile;

ALTER SYSTEM ARCHIVE LOG START;


alter system set db_recovery_file_dest_size=120G scope=spfile;
alter system set java_pool_size=128M scope=spfile;
alter system set large_pool_size=128M scope=spfile;
alter system set shared_pool_reserved_size=96M scope=spfile;
alter system set shared_pool_size=128M scope=spfile;
alter system set sga_min_size=1G scope=spfile;
alter system set sga_max_size=4G scope=spfile;
alter system set large_pool_size=128M scope=spfile;
create pfile from spfile;


!ps -ef | grep arc

