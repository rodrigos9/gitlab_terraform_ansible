#!/bin/bash

public_ip=`curl ifconfig.me`

printf '{"public_ip" : "%s"}\n' "$public_ip"
