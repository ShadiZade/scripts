#!/bin/bash
source ~/Repositories/scripts/essential-functions
shows="$usdd/shows.csv"

function get-series {
    echolor blue-white "$1 ““∎∎”” " 1
    curlo="$(curl -s "https://thetvdb.com/series/$2")"
    upcoming="$(echo "$curlo" | grep -i -C 3 'strong>upcoming' | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ,$'\r')"
    recent="$(echo "$curlo" | grep -i -C 3 recent | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ',' | tr -d $'\r')"
    status="$(echo "$curlo" | grep -i -C 2 status | tail -n 1 | awk '{print $1}' | cut -c-4)"
    [[ -z "$upcoming" ]] && upcoming="““no upcoming””"
    [[ -z "$recent" ]] && recent="““unreleased””"
    [[ "$status" = "Ende" ]] && upcoming="\033[31mshow has ended\033[0m"
    echolor white-black "$recent" 1
    if [[ ! "$recent" = "““unreleased””" ]]
    then
	[[ "$(date -d "$recent" '+%Y%m%d')" = "$(date '+%Y%m%d')" ]] && echolor red ' •' 1
	[[ "$(date -d "$recent" '+%Y%m%d')" = "$(date -d yesterday '+%Y%m%d')" ]] && echolor red ' ••' 1
	[[ "$(date -d "$recent" '+%Y%m%d')" = "$(date -d '2 days ago' '+%Y%m%d')" ]] && echolor red ' •••' 1
    fi
    echolor yellow-black "\n\t$upcoming" 1
    if [[ ! "$upcoming" = "““no upcoming””" ]] && [[ ! "$upcoming" = "\033[31mshow has ended\033[0m" ]]
    then
	[[ "$(date -d "$upcoming" '+%Y%m%d')" = "$(date -d '3 days' '+%Y%m%d')" ]] && echolor green '\r •••' 1
	[[ "$(date -d "$upcoming" '+%Y%m%d')" = "$(date -d '2 days' '+%Y%m%d')" ]] && echolor green '\r ••' 1
	[[ "$(date -d "$upcoming" '+%Y%m%d')" = "$(date -d tomorrow '+%Y%m%d')" ]] && echolor green '\r •' 1
	[[ "$(date -d "$upcoming" '+%Y%m%d')" = "$(date '+%Y%m%d')" ]]             && echolor green '\r >>>' 1
    fi
    echo
	
}

IFS=$'\n'
for j in $(cat "$shows" | sed '/^#/d')
do
    name="$(echo "$j" | xsv select 1)"
    url="$(echo "$j" | xsv select 2)"
    get-series "$name" "$url"
done
unset IFS
