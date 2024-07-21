#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

function get-series {
    echolor blue-white "$1 ““::”” " 1
    curlo="$(curl -s "https://thetvdb.com/series/$2")"
    upcoming="$(echo "$curlo" | grep -i -C 3 'strong>upcoming' | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ',')"
    recent="$(echo "$curlo" | grep -i -C 3 recent | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ',')"
    status="$(echo "$curlo" | grep -i -C 2 status | tail -n 1 | awk '{print $1}' | cut -c-4)"
    [[ -z "$upcoming" ]] && upcoming="““no upcoming””"
    [[ -z "$recent" ]] && recent="““unreleased””"
    [[ "$status" = "Ende" ]] && upcoming="\033[31mshow has ended\033[0m"
    echolor white-black "$recent"
    echolor yellow-black "\t$upcoming"
}

get-series "Lower Decks" "star-trek-lower-decks"
get-series "Strange New Worlds" "star-trek-strange-new-worlds"
get-series "Star Wars: Andor" "andor"
get-series "The Mandalorian" "the-mandalorian"
get-series "Severance" "severance"
get-series "Game Changer" "game-changer"
get-series "Very Important People" "440147-very-important-people"
get-series "Smartypants" "smartypants"
get-series "Thousandaires" "thousandaires"
get-series "House of the Dragon" "house-of-the-dragon"
get-series "Sunny" "sunny"
get-series "Time Bandits" "time-bandits"
get-series "The Decameron" "the-decameron"
