#!/bin/sh
set -eu
# The common module overrides HanLP classes and must precede the upstream JAR.
set -- /app/lib/common-*.jar
if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
  echo 'Expected exactly one SuperSonic common module JAR.' >&2
  exit 1
fi
exec java -Xms256m -Xmx1536m -Dfile.encoding=UTF-8 \
  -Duser.timezone=Asia/Shanghai \
  -cp "/app/conf:/app/webapp:$1:/app/lib/*" \
  com.tencent.supersonic.StandaloneLauncher
