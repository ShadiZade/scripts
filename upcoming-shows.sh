#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

function clean-o {
    curlo="$(curl -s "$1")"
    upcoming="$(echo "$curlo" | grep -i -C 3 'strong>upcoming' | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ',')"
    recent="$(echo "$curlo" | grep -i -C 3 recent | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ',')"
    status="$(echo "$curlo" | grep -i -C 2 status | tail -n 1 | awk '{print $1}' | cut -c-4)"
    [[ -z "$upcoming" ]] && upcoming="\033[30mno upcoming\033[0m"
    [[ "$status" != "Cont" ]] && upcoming="\033[31mshow has ended\033[0m"
    export recent
    export upcoming
}

function print-out {
    clean-o "https://thetvdb.com/$2"
    echolor blue "$1: ““$recent””"
    echolor yellow "\t$upcoming"
}

print-out "Lower Decks" "series/star-trek-lower-decks"
print-out "Our Flag Means Death" "series/our-flag-means-death"
print-out "Game Changer" "series/game-changer"
print-out "The Mandalorian" "series/the-mandalorian"
print-out "Severance" "series/severance"
print-out "Strange New Worlds" "series/star-trek-strange-new-worlds"
