#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [ "$(node -p 'process.versions.node.split(".")[0]')" != 20 ]; then
  echo 'Use Node 20 for the existing frontend dependencies before building.' >&2
  exit 1
fi
mvn -pl launchers/standalone -am package -DskipTests -Dspotless.skip=true
(cd webapp/packages/chat-sdk && npm run build)
(cd webapp/packages/supersonic-fe && NODE_OPTIONS=--openssl-legacy-provider npm run build:os-local)
version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
stage=assembly/deploy/local
mkdir -p "$stage"
rm -rf "$stage/conf" "$stage/lib" "$stage/bin" "$stage/webapp"
tar -xzf "launchers/standalone/target/launchers-standalone-${version}-bin.tar.gz" -C "$stage" --strip-components=1
mkdir -p "$stage/webapp/webapp"
cp -R webapp/packages/supersonic-fe/supersonic-webapp/. "$stage/webapp/webapp/"
printf '{"env":""}\n' > "$stage/webapp/webapp/supersonic.config.json"
docker build -f docker/Dockerfile.local -t supersonic-local:dev .
