#!/usr/bin/env bash
CURPATH=$(pwd)

# prerequisite:
# using node 10
# npm install pkg@4.3.7 -g

# https://gist.github.com/DarrenN/8c6a5b969481725a4413
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')
PACKAGE_VERSION_NO_WHITESPACE="$(echo -e "${PACKAGE_VERSION}" | tr -d '[:space:]')"
OUTFILE="sushipool-opencl-miner-linux-${PACKAGE_VERSION_NO_WHITESPACE}.tar.gz"
echo "Building ${OUTFILE}"
export PACKAGING="1" # set to 1 so nimiq builds the optimised node files for all cpus

rm -rf node_modules
yarn
rm -rf dist
mkdir dist
pkg -t node10-linux index.js
mv index dist/sushipool-opencl-miner

cp build/Release/nimiq_miner.node dist/
cp node_modules/node-lmdb/build/Release/node-lmdb.node dist/
cp node_modules/cpuid-git/build/Release/cpuid.node dist/
cp node_modules/@nimiq/core/build/Release/*.node dist/
cp dist/nimiq_node_compat.node dist/nimiq_node_sse2.node
rm dist/nimiq_node_native.node
cp miner.sample.conf dist
cp start_gpu.sh dist

echo "Create tar.gz"
cd dist/
tar cvzf ../${OUTFILE} *
cd ..
mv ${OUTFILE} dist/
