--### GOTO PRIMARY
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

PROMPT Switchover to Primary
ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;

PROMPT Shutdown standby database
SHUTDOWN IMMEDIATE;

PROMPT Open old standby database as primary
STARTUP;

@status

