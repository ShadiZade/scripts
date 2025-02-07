#!/bin/bash
source ~/Repositories/scripts/essential-functions

function load-global-variables {
    dx_day0="2025-02-09"
    dx_day1="2025-02-10"
    zhou_chars=(z 刊)
    rydyng_chars=(y 义 而 森)
    dodec_chars=(d 刃 技 凰 兴 琴 从 查 刷 汇 讴 叫 汝 云 罡 功 更 红 绕 幺 套 织 韭 飘 贝 庶 忠 郭 仍 存 幽)
    ram_chars=(r 闯 岸 豹 斐 顶 卫 田 审 启 剀 矛 匝)
}   
function load-math-functions {
    function math-ceiling {
	perl -w -e "use POSIX; print ceil($1), qq{\n}"
    }
    function math-floor {
	perl -w -e "use POSIX; print floor($1), qq{\n}"
    }
}


function test-date-validity {
    datetest --isvalid "$@" || return 1
    datetest "$dx_day0" --ot "$@" || return 1
}

function format-dx-string {
    [[ -z "$3" ]] && return 1
    if [[ -z "$4" ]]
    then
	printf "%.2d.%.2d.%.2d" "$1" "$2" "$3"
    else
	printf "%.2d.%.1d.%.2d.%.2d" "$1" "$2" "$3" "$4"
    fi
}

function gx-dx-convert {
    # converts the date from Georgian to Dodecaphony
    test-date-validity "$@" || return 1
    local rams_since_day0="$(datediff "$dx_day0" "$@")"
    # basically epoch for dx
    local ram_in_zhou="$(((rams_since_day0 - 1 ) % 360 + 1))"
    # {1..360}
    local zhous_since_day0="$((rams_since_day0 / 360 + 1))" # bash can't do float, basically floor function
    # z1 begins on dx_day1
    local rydyng_in_zhou="$((ram_in_zhou / 120 + 1))"
    # {1..3}
    local dodec_in_zhou="$(((ram_in_zhou - 1 ) / 12 + 1))"
    # {1..30}
    local ram_in_dodec="$(((ram_in_zhou - 1 ) % 12 + 1 ))"
    # {1..12}
    format-dx-string "$zhous_since_day0" "$rydyng_in_zhou" "$dodec_in_zhou" "$ram_in_dodec"
    #format-dx-string "$zhous_since_day0" "$dodec_in_zhou" "$ram_in_dodec"
}


function test-valid-dx-string {
    [[ -z "$@" ]] && return 1
    grep -q '\.' <<< "$@" || return 1
    grep -q '/' <<< "$@" && return 1
    grep -q '[a-zA-Z ]' <<< "$@" && return 1
    [[ "$(printf "$@" | wc -c)" -gt 10 ]] && return 1
    [[ "$(printf "$@" | wc -c)" -lt 8 ]] && return 1
    [[ "$(printf "$@" | sed 's/[^.]//g' | wc -c)" -gt 3 ]] && return 1
    [[ "$(printf "$@" | sed 's/[^.]//g' | wc -c)" -lt 2 ]] && return 1
    :
}

function no-of-fields-in-dx-string {
    [[ -z "$@" ]] && return 1
    test-valid-dx-string "$@" || return 1
    printf "$@" | awk -F '.' '{print NF}'
}

function extract-from-dx-string {
    [[ -z "$1" || -z "$2" ]] && return 1
    test-valid-dx-string "$2" || return 1
    if [[ "$(no-of-fields-in-dx-string "$2")" -eq 4 ]]
    then
	case "$1" in
	    z) cut -d '.' -f 1 <<< "$2";;
	    y) cut -d '.' -f 2 <<< "$2";;
	    d) cut -d '.' -f 3 <<< "$2";;
	    r) cut -d '.' -f 4 <<< "$2";;
	    *) return 1 ;;
	esac
    else
	case "$1" in
	    z) cut -d '.' -f 1 <<< "$2";;
	    d) cut -d '.' -f 2 <<< "$2";;
	    r) cut -d '.' -f 3 <<< "$2";;
	    *) return 1 ;;
	esac
    fi
}

function truncate-y-from-dx-string {
    local ex_z="$(extract-from-dx-string z "$@")"
    local ex_d="$(extract-from-dx-string d "$@")"
    local ex_r="$(extract-from-dx-string r "$@")"
    printf "$ex_z.$ex_d.$ex_r"
}

function test-valid-dx-string-values {
    :
}

function give-char {
    [[ -z "$2" ]] && return 1
    local char_index="$(printf '%.d' "${2##0}")"
    case "$1" in
	z) echo ${zhou_chars[$char_index]:-甚};;
	y) echo ${rydyng_chars[$char_index]:-甚};;
	d) echo ${dodec_chars[$char_index]:-甚};;
	r) echo ${ram_chars[$char_index]:-甚};;
	*) return 1 ;;
    esac
}

function give-chars-for-dx-string {
    [[ -z "$@" ]] && return 1
    local ch_z="$(give-char z $(extract-from-dx-string z "$@"))"
    [[ "$(no-of-fields-in-dx-string "$2")" -eq 3 ]] || local ch_y="$(give-char y $(extract-from-dx-string y "$@"))"
    local ch_d="$(give-char d $(extract-from-dx-string d "$@"))"
    local ch_r="$(give-char r $(extract-from-dx-string r "$@"))"
    printf "$ch_z$ch_y$ch_d$ch_r"
}


function command-option {
    function field {
	cut -d ' ' -f "$2" <<< "$1"
    }
    case "$(field "$@" 1)" in
	"today")
	    gx-dx-convert "$(date +"%Y-%m-%d")" || exit 1
	    echo
	    ;;
	"today-char")
	    give-chars-for-dx-string "$(gx-dx-convert "$(date +"%Y-%m-%d")")" || exit 1
	    echo
	    ;;
	"to-dx")
	    gx-dx-convert "$(field "$@" 2)" || exit 1
	    echo
	    ;;
	"to-dx-char")
	    local dx_date="$(gx-dx-convert "$(field "$@" 2)")"
	    give-chars-for-dx-string "$dx_date" || exit 1
	    echo
	    ;;
	"to-dx-no-y")
	    local dx_date="$(gx-dx-convert "$(field "$@" 2)")"
	    truncate-y-from-dx-string "$dx_date" || exit 1
	    echo
	    ;;
	"to-dx-no-y-char")
	    local dx_date="$(gx-dx-convert "$(field "$@" 2)")"
	    local dx_date="$(truncate-y-from-dx-string "$dx_date")"
	    give-chars-for-dx-string "$dx_date" || exit 1
	    echo
	    ;;
	*)
	    echo ":: Unknown command."
	    exit 1
	    ;;
    esac
}

load-global-variables
load-math-functions
while getopts 'c:' OPTION; do
    case "$OPTION" in
	"c") command-option "$OPTARG" ;;
	*) echo incorrect input; exit ;;
	esac
done
(( $OPTIND == 1 )) && command-option today
# gx-dx-convert "$1"
# echo
# give-chars-for-dx-string $(gx-dx-convert "$1")
# echo

