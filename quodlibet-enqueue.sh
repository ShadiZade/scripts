#!/bin/bash
quodlibet --enqueue="\"$(quodlibet --print-playing | awk -F ' - ' '{print $NF}')\""
