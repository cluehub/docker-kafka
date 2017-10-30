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

mirror=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | sed -nE "s/^.*\"preferred\"[[:space:]]*:[[:space:]]*\"(.*)\"/\1/p")
url="${mirror}kafka/${KAFKA_VERSION}/${KAFKA_FILE_NAME}.tgz"

echo "-- downloading from $mirror"
echo "-- kafka keys"
{ wget -q "${mirror}kafka/KEYS" -O "${KAFKA_KEYS}"; } &
echo "-- kafka signature ${url}.asc"
{ wget -q "${url}.asc" -O "${KAFKA_SIG}"; } &
echo "-- kafka archive ${url}"
{ wget -q "${url}" -O "${KAFKA_ARCHIVE}"; } &
wait
