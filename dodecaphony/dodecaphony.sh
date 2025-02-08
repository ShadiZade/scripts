#!/bin/bash
source ~/Repositories/scripts/essential-functions

function load-global-variables {
    dx_day0="2025-02-09"
    dx_day1="2025-02-10"
    zhou_chars=(z 刊)
    rydyng_chars=(y 义 而 森)
    dodec_chars=(d 刃 技 凰 兴 琴 从 查 刷 汇 讴 叫 汝 云 罡 功 更 红 绕 幺 套 织 韭 飘 贝 庶 忠 郭 仍 存 幽)
    ram_chars=(r 闯 岸 豹 斐 顶 卫 田 审 启 剀 矛 匝)
    zhou_color='38;2;80;118;148'
    rydyng_color='38;2;69;72;206'
    dodec_color='38;2;93;205;217'
    ram_color='38;2;254;248;236'
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
#    sane "$1"
    test-date-validity "$1" || return 1
    local rams_since_day0="$(datediff "$dx_day0" "$1")"
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
    [[ "$2" = "4" || -z "$2" ]] && {
	format-dx-string "$zhous_since_day0" "$rydyng_in_zhou" "$dodec_in_zhou" "$ram_in_dodec"
	return 0
    }
    [[ "$2" = "3" ]] && {
	format-dx-string "$zhous_since_day0" "$dodec_in_zhou" "$ram_in_dodec"
	return 0
    }
    printf "$(sed "s/z/$zhous_since_day0/g;s/y/$rydyng_in_zhou/g;s/d/$dodec_in_zhou/g;s/r/$ram_in_dodec/g" <<< "$2")"
}

function color-number {
    [[ -z "$1" || -z "$2" ]] && return 1
    case "$1" in
	z) printf "\033[${zhou_color}m%.2d" "${2##0}";;
	y) printf "\033[${rydyng_color}m%.1d" "${2##0}";;
	d) printf "\033[${dodec_color}m%.2d" "${2##0}";;
	r) printf "\033[${ram_color}m%.2d" "${2##0}";;
	*) return 1 ;;
    esac
    printf '\033[0m'
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

function key-parser {
    [[ -z "$@" ]] && return 1
    keys=(keys ${@/:/ })
}

function give-char {
    [[ -z "$2" || -z "$1" ]] && return 1
    local char_index="$(printf '%.d' "${2##0}")"
    key-parser "$3"
    for j in ${keys[@]}
    do
	case "$j" in
	    "keys") : ;;
	    "color") local zhou_color_sequence="\033[${zhou_color}m"
		     local rydyng_color_sequence="\033[${rydyng_color}m"
		     local dodec_color_sequence="\033[${dodec_color}m"
		     local ram_color_sequence="\033[${ram_color}m";;
	    *) : ;;
	esac
    done
    case "$1" in
	z) printf "$zhou_color_sequence${zhou_chars[$char_index]:-甚}";;
	y) printf "$rydyng_color_sequence${rydyng_chars[$char_index]:-甚}";;
	d) printf "$dodec_color_sequence${dodec_chars[$char_index]:-甚}";;
	r) printf "$ram_color_sequence${ram_chars[$char_index]:-甚}";;
	*) return 1 ;;
    esac
    printf '\033[0m'
}

function give-chars-for-dx-string {
    [[ -z "$1" ]] && return 1
    key-parser "$2"
    for j in ${keys[@]}
    do
	case "$j" in
	    "keys") : ;;
	    "color") local passkey+=":color";;		     
	    *) : ;;
	esac
    done
    local ch_z="$(give-char z $(extract-from-dx-string z "$1" "$passkey"))"
    [[ "$(no-of-fields-in-dx-string "$2")" -eq 3 ]] || {
	local ch_y="$(give-char y $(extract-from-dx-string y "$1" "$passkey"))"
    }
    local ch_d="$(give-char d $(extract-from-dx-string d "$1" "$passkey"))"
    local ch_r="$(give-char r $(extract-from-dx-string r "$1" "$passkey"))"
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
	"pretty")
	    test-date-validity "$(field "$@" 2)" || return 1
	    printf "\033[${zhou_color}m∎\033[${rydyng_color}m∎\033[${dodec_color}m∎\033[${ram_color}m∎\033[0m "
	    color-number z "$(gx-dx-convert "$(field "$@" 2)" z)"
	    printf .
	    color-number y "$(gx-dx-convert "$(field "$@" 2)" y)"
	    printf .
	    color-number d "$(gx-dx-convert "$(field "$@" 2)" d)"
	    printf .
	    color-number r "$(gx-dx-convert "$(field "$@" 2)" r)"
	    printf ' '
	    give-chars-for-dx-string "$(gx-dx-convert "$(field "$@" 2)" 4)" color
	    printf '\n'
	    ;;
	"to-dx")
	    gx-dx-convert "$(field "$@" 2)" || exit 1
	    echo
	    ;;
	"to-dx-char")
	    local dx_date="$(gx-dx-convert "$(field "$@" 2)")"
	    give-chars-for-dx-string "$dx_date" "$(field "$@" 3)" || exit 1
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
	"test")
	    color-number r 3
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

