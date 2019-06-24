#!/usr/bin/env bash

systemctl stop ufw
systemctl disable ufw
systemctl start rpcbind
systemctl enable rpcbind
