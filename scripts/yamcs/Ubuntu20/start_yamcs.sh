#!/bin/sh

# Variables
# ---------
# DO NOT MODIFY THIS FILE
# Instead set variables via a script YAMCS_HOME/bin/setenv.sh
#
# JMX           Set to 1 to allow remote JMX connections (jconsole).
#               (only temporarily for debugging purposes !)
#
# JAVA_OPTS     Java runtime options
#
# CLASSPATH     Custom classpath additions

# resolve links - $0 may be a softlink
PRG="$0"
YAMCS_HOME="$1"
WORKSPACE_PATH="$2"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# cd into the workspace to support relative links in configuration files
cd "$WORKSPACE_PATH"

echo $WORKSPACE_PATH

# Remove user classpath, but allow custom classpath additions via setenv.sh
CLASSPATH=

if [ -r bin/setenv.sh ]; then
  . bin/setenv.sh
fi

if [ "x$CLASSPATH" != x ]; then
  CLASSPATH="$CLASSPATH:"
fi

echo ${PWD}

export CLASSPATH="$CLASSPATH$YAMCS_HOME/lib/*:$YAMCS_HOME/lib/ext/*:$WORKSPACE_PATH/lib/*"

if [ -d "$JAVA_HOME" ]; then
  _RUNJAVA="$JAVA_HOME/bin/java"
else
  _RUNJAVA=java
fi
exec "$_RUNJAVA" $JAVA_OPTS $JMX_OPTS -Djava.util.logging.manager=org.yamcs.logging.YamcsLogManager -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/ org.yamcs.YamcsServer

                                                                                                                                                                                                 1,1           Top
