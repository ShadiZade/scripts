#!/bin/bash

fc-list -f '%{family}\n' | awk '!x[$0]++' | awk -F ',' '{print $1}' | sort | uniq | grep -iv "noto" | grep -iv "math"
