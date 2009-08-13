#!/bin/bash
pushd ../WordnetOcaml-0.1 > /dev/null
./related.sh $*
popd > /dev/null
