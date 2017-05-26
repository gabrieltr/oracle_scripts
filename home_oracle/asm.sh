﻿setenv ORACLE_HOME /oracle/EQ0/11204/grid
setenv ORACLE_SID +ASM
setenv ORACLE_BIN $ORACLE_HOME/bin

if (! $?PATH_ORIGINAL ) then
  setenv PATH_ORIGINAL $PATH
endif

setenv PATH $PATH_ORIGINAL":$ORACLE_BIN"

echo ""
echo $ORACLE_HOME;
echo $ORACLE_BIN;
echo $ORACLE_SID;
echo $PATH;

set prompt="$ORACLE_SID@`uname -n` % "

alias sp "$ORACLE_BIN/sqlplus / as sysasm"
alias cdoh "cd $ORACLE_HOME"
alias cdon "cd $ORACLE_HOME/network/admin"
alias asmcmd "asmcmd -p"