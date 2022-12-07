#!/bin/bash 

copyq copy "$(echo $(pwd)/$(ls -1 | grep $1))"
