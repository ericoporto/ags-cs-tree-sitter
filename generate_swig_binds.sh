#!/bin/bash

echo "Updating git submodules... "
git submodule update --init --recursive
echo "DONE"
pushd tree-sitter-ags-script/src
echo "Applying patch... "
patch parser.c ../../parser.c.patch
echo "DONE"
echo "Copying necessary headers... "
cp ../../parser.h ./parser.h
echo "DONE"
echo "Copying necessary swig interface... "
cp ../../parser.i ./parser.i
echo "DONE"
echo "Generating parser wrapper... "
swig -csharp parser.i -outdir ../../generated/parser
echo "DONE"
popd
swig -csharp api.i -outdir generated/api

