--### GOTO STANDBY

--!lsnrctl stop

prompt switchover to standby
ALTER DATABASE COMMIT TO SWITCHOVER TO STANDBY;

--prompt shutdown...
--SHUTDOWN IMMEDIATE;

prompt Starting standby read only
STARTUP MOUNT;
ALTER DATABASE OPEN READ ONLY;

--STARTUP NOMOUNT;
--ALTER DATABASE MOUNT STANDBY DATABASE;

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

--!lsnrctl start

@status