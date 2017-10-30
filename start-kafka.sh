#!/bin/bash

# Copyright 2017 Cluehub
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

configure () {
  VAR_PREFIX=$1
  CONF_PREFIX=$2
  FILE=$3
  KEY=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
  VAL=`echo "$VAR" | sed -r "s/.*=(.*)/\1/g"`
  NAME=`echo "$VAR" | sed -r "s/$VAR_PREFIX(.*)=.*/$CONF_PREFIX\1/g" | tr _ .`
  if egrep -q "^[[:space:]]*$NAME=" $FILE; then
      ESCAPED_VAL=$(echo $VAL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')
      sed -r -i "s/(^[[:space:]]*$NAME)=(.*)/\1=$ESCAPED_VAL/g" $FILE
  else
      echo "$NAME=${VAL}" >> $FILE
  fi
}

for VAR in `env`; do
  if [[ $VAR =~ ^KAFKA_SERVER_ ]]; then
    configure "KAFKA_SERVER_" "" "$KAFKA_HOME/config/server.properties"
  elif [[ $VAR =~ ^KAFKA_LOG4J_ ]]; then
    configure "KAFKA_LOG4J_" "log4j." "$KAFKA_HOME/config/log4j.properties"
  fi
done

exec $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
