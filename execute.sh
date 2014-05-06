#!/bin/sh

cd src/
make text_all
cd ..

./bin/mttt < inputs.txt
