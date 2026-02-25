#!/bin/bash
source ~/Repositories/scripts/essential-functions
shows="$usdd/shows.csv"

function get-series {
    echolor blue-white "““Show:”” $1 ““∎∎”” " 1
    curlo="$(curl -s "https://thetvdb.com/series/$2")"
    upcoming="$(echo "$curlo" | grep -i -C 3 'strong>upcoming' | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ,$'\r')"
    recent="$(echo "$curlo" | grep -i -C 3 'strong>recent' | tail -n 1 | awk '{print $2,$1,$3}' | tr -d ',' | tr -d $'\r')"
    status="$(echo "$curlo" | grep -i -C 2 'strong>status' | tail -n 1 | awk '{print $1}' | cut -c-4)"
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

function get-movie {
    echolor white-blue "““Film:”” $1 ““∎∎”” " 1
    curlo="$(curl -s "https://www.allmovie.com/movie/$2")"
    releasedate="$(echo "$curlo" | grep 'Release Date' | hq span text | xargs -I DATE date -d DATE +"%d %B %Y")"
    beside=''
    under=''
    [[ -z "$releasedate" ]] && {
	echolor black "unknown"
	echolor black "\tunknown"
	return
    }
    if datetest "$(date -I -d "$releasedate")" --lt "$(date -I -d today)"
    then
	beside="$releasedate"
	under="““released””"
    else
	beside="““unreleased””"
	under="$releasedate"
    fi
    echolor blue-black "$beside" 1
    if [[ ! "$beside" = "““unreleased””" ]]
    then
	[[ "$(date -d "$beside" '+%Y%m%d')" = "$(date '+%Y%m%d')" ]] && echolor red ' •' 1
	[[ "$(date -d "$beside" '+%Y%m%d')" = "$(date -d yesterday '+%Y%m%d')" ]] && echolor red ' ••' 1
	[[ "$(date -d "$beside" '+%Y%m%d')" = "$(date -d '2 days ago' '+%Y%m%d')" ]] && echolor red ' •••' 1
    fi
    echolor yellow-black "\n\t$under" 1
    if [[ ! "$under" = "““released””" ]]
    then
	[[ "$(date -d "$under" '+%Y%m%d')" = "$(date -d '3 days' '+%Y%m%d')" ]] && echolor green '\r •••' 1
	[[ "$(date -d "$under" '+%Y%m%d')" = "$(date -d '2 days' '+%Y%m%d')" ]] && echolor green '\r ••' 1
	[[ "$(date -d "$under" '+%Y%m%d')" = "$(date -d tomorrow '+%Y%m%d')" ]] && echolor green '\r •' 1
	[[ "$(date -d "$under" '+%Y%m%d')" = "$(date '+%Y%m%d')" ]]             && echolor green '\r >>>' 1
    fi
    echo
	
}


IFS=$'\n'
for j in $(cat "$shows" | sed '/^#/d')
do
    class="$(echo -n "$j" | xan select 0)"
    name="$(echo -n "$j" | xan select 1)"
    url="$(echo -n "$j" | xan select 2)"
    case "$class" in
	"tv"|"show"|"series"|"tvseries")
	    get-series "$name" "$url" ;;
	"film"|"movie"|"movingpicture"|"hollywoodslop")
	    get-movie "$name" "$url" ;;
	*)
	    echolor red ":: Unknown classification ““$class”” for ““$name””" ;;
    esac
	      
done
unset IFS
