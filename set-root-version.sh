#!/bin/bash

set -euo pipefail
source "$(realpath "$(dirname $0)/environment.sh")"

# expected arguments: <major.minor.patch[-<suffix>]>

VERSION=$1
major=${VERSION%%.*}
major=${major#v}
minor=${VERSION#*.}
minor=${minor%%.*}
patch=${VERSION##*.}
patch=${patch%%-*}
suffix=${VERSION#*-}
if [[ "$suffix" == "$VERSION" ]]; then
  suffix=""
fi

version_file="$PROJECT_ROOT/pkg/version/static_version.go"
file_mode=$(stat -c '%a' "$version_file")
version="v${major}.${minor}.${patch}${suffix:+-}${suffix}"

cat << EOF > "$version_file"
// Do not modify this file directly, as it is auto-generated.
package version

var StaticVersion = "${version}"
EOF
chmod $file_mode "$version_file"
