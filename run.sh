#!/bin/sh

cd /ergo
./ergo mkcerts || echo
./ergo run & 
cd /kiwiirc
./kiwiirc
