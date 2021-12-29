#!/bin/bash

service ssh start
echo 'root:9zcdI,' | chpasswd 
useradd -s /bin/bash -g adm -m qq
echo 'qq:q6q89,' | chpasswd

bash

