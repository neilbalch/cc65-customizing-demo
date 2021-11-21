#!/usr/bin/env bash

make
cd template
make clean && make run
cd ..

cp template/dump/arcade.bin $1.arcade.bin
cp template/dump/zero.bin $1.zero.bin
