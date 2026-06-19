#!/bin/bash -

# set -xeuo pipefail

rm -f .link*

# Kerbal Space Program is linux-native.

ln -s "${HOME}/.steam/debian-installation/steamapps/"           .link-steamapps
ln -s ".link-steamapps/common/Kerbal Space Program/"            .link-ksp
ln -s ".link-ksp/saves/"                                        .link-saves

ln -s ".link-saves/default"                                     Saves

for l in .* *
do
    [ -h "$l" ] || continue
    t=$(readlink "$l")
    printf "%s -> %s\n" "$l" "$t"
done
