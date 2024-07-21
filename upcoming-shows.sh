#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
shows="$usdd/shows.csv"

function get-series {
    echolor blue-white "$1 ““∎∎”” " 1
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

IFS=$'\n'
for j in $(cat "$shows" | sed 1d | sed '/^#/d')
do
    name="$(echo "$j" | xsv select 1)"
    url="$(echo "$j" | xsv select 2)"
    get-series "$name" "$url"
done
