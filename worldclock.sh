#!/bin/bash
echo ""
echo -e "Your current timezone is \033[32;1;4m$(date +'%H:%m on %A')\033[0m"
echo -e "Universal Coördinated Time is \033[32;1;4m$(date -u +'%H:%m on %A')\033[0m"
echo ""
echo -e "\033[4mNew York\033[0m time is \033[32;1;4m$(TZ='America/New_York' date +'%H:%m on %A')\033[0m"
echo -e "\033[4mShanghai\033[0m time is \033[32;1;4m$(TZ='Asia/Shanghai' date +'%H:%m on %A')\033[0m"
echo -e "\033[4mManila\033[0m time is \033[32;1;4m$(TZ='Asia/Manila' date +'%H:%m on %A')\033[0m"
