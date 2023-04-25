#!/usr/bin/env bash

# install from rpm package with the specified version.

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

case $(uname -m) in
    "x86_64") ARCH="x86_64" ;;
    "aarch64") ARCH="aarch64" ;;
    *) echo "Unknown architecture $(uname -m)";
esac

RPM_URL="https://packages.clickhouse.com/rpm/stable"

for PKG in "clickhouse-common-static" "clickhouse-server"
do
    curl -fO "$RPM_URL/$PKG-$VERSION.$ARCH.rpm"
    sudo rpm -i "$RPM_URL/$PKG-$VERSION.$ARCH.rpm"
done
