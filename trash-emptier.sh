#!/bin/bash
source ~/Repositories/scripts/essential-functions

trash_dir="$HOME/.local/share/Trash/files"
trash_manifest="$HOME/.local/share/Trash/deletetimes"
log_dir="$HOME/.local/logs/trash"
current_time="$(date-string)"
trash_size="$(du -sh "$trash_dir" 2>/dev/null | awk '{print $1}')"
emptying_log="$log_dir"/emptying/emptying-"$current_time.log"
mem_before="$(df | grep ' /$' | awk '{print $5}')"

function manifest-log {
    [[ -d "$log_dir" ]] || {
	mkdir "$log_dir"
	echolor yellow ":: Created log directory at ““$log_dir””"
    }
    echolor yellow-purple ":: Current time is ““$current_time””"
    echolor yellow ":: Backing up trash manifest to ““$log_dir””"
    [[ -d "$log_dir"/manifests ]] || {
	mkdir "$log_dir"/manifests
	echolor yellow ":: Created manifests log directory at ““${log_dir}/manifests””"
    }
    cp -- "$trash_manifest" "$log_dir"/manifests/manifest-"$current_time"
    echo "$current_time" >> "$log_dir"/emptytimes
    [[ -d "$log_dir"/emptying ]] || {
	mkdir "$log_dir"/emptying
	echolor yellow ":: Created emptying log directory at ““${log_dir}/emptying””"
    }
    touch "$emptying_log"
}

function safety-checks {
    safe_check=0
    echolor green ":: Running safety checks..."
    echolor green ":: ““[1/8]”” Trash directory definition is not empty... " 1
    [[ -z "$trash_dir" ]] && {
	echolor red "[FAIL]"
    } || {
	echolor white "[PASS]"
	((safe_check++))
    }
    echolor green ":: ““[2/8]”” Trash directory definition contains the word 'trash'... " 1
    echo -n "$trash_dir" | grep -qi "trash" && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[3/8]”” Trash directory exists... " 1
    [[ -d "$trash_dir" ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }	
    echolor green ":: ““[4/8]”” Trash manifest exists... " 1
    [[ -e "$trash_manifest" ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[5/8]”” Trash manifest has been backed up... " 1
    [[ -e "$log_dir"/manifests/manifest-"$current_time" ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[6/8]”” Trash directory is not empty... " 1
    [[ "$(eza -1a "$trash_dir" 2>/dev/null | wc -l )" -gt 0 ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[7/8]”” Emptying log file exists... " 1
    [[ -e "$log_dir/emptying/emptying-$current_time.log" ]] && {
		echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[8/8]”” File spot checks... " 1
    spot_check_fail=0
    if [[ -s "$log_dir"/manifests/manifest-"$current_time" ]]
    then
	IFS=$'\n'
	for m in $(sed 10q "$log_dir"/manifests/manifest-"$current_time")
	do
	    fd -FHq -- "$(echo "$m" | awk -F '   ¼⅓   ' '{print $2}')" "$trash_dir" || {
		echo "test 8 failed to find $(echo "$m" | awk -F '   ¼⅓   ' '{print $2}')" >> "$emptying_log"
		spot_check_fail=1
		echolor red "[FAIL]"
		break
	    }
	done
	[[ "$spot_check_fail" -eq 0 ]] && {
	    echolor white "[PASS]"
	    ((safe_check++))
	}
    else
	echolor red "[FAIL]"
    fi
    unset IFS
    echolor green-purple ":: Safety score is ““${safe_check}”” out of 8"
    export safe_check
}


function visual-check {
    echolor purple ":: Give the information a visual once-over to confirm nothing has gotten past the code."
    echolor purple ":: Trash directory: ““$trash_dir””"
    echolor purple ":: Trash manifest: ““$trash_manifest””"
    echolor purple ":: Trash directory size: ““$trash_size””"
    echolor purple ":: Number of files in trash: ““$(eza -1a "$trash_dir" | wc -l)””"
    echolor green ":: Please type the ““trash directory size”” to confirm and continue."
    echo -n "> "
    read -r visual_p
    export visual_p
}


function empty-trash {
    files_deleted=0
    cd "$trash_dir"
    echolor yellow ":: Emptying trash..."
    IFS=$'\n'
    for j in $(eza -1aX --no-quotes "$trash_dir"); do
	[[ -z "$j" ]] && {
	    echo "fatal error 01 $j" >> "$emptying_log" 
	    echolor red ":: FATAL ERROR: Script attempted to delete an nonexistent file"
	    echolor red ":: Crashing out, standing by to avoid causing damage. ““$files_deleted”” files already deleted."
	    echolor red ":: Info:"
	    echolor red "\t- File name (should be empty): ““$j””"
	    echolor red "\t- Previous deleted file: ““$previously_deleted””"
	}
	[[ -e "$trash_dir"/"$j" ]] || {
	    echo "fatal error 02 $j" >> "$emptying_log" 
	    echolor red ":: FATAL ERROR: Script attempted to delete file ““$j””, which doesn't exist inside trash"
	    echolor red ":: Crashing out, standing by to avoid causing damage. ““$files_deleted”” files already deleted."
	    echolor red ":: Info:"
	    echolor red "\t- Real path: ““$(realpath "$j")””"
	    echolor red "\t- Base name: ““$(basename "$j")””"
	    echolor red "\t- Appearance in eza: ““$(eza -1a --no-quotes "$trash_dir" | grep "$j")””"
	    echolor red "\t- Safety search pattern: ““$trash_dir/$j””"
	    echolor red "\t- Previous deleted file: ““$previously_deleted””"
	    return
	}
	echo "deleting $j" >> "$emptying_log"
	rm -rf -- "$trash_dir/$j"
	((files_deleted++))
	printf "\r$files_deleted"
	previously_deleted="$j"
    done
    echo
    echolor yellow-purple ":: Done. Deleted ““$files_deleted”” files."
    [[ "$(eza -1a "$trash_dir" | wc -l)" -ne 0 ]] && {
	echo "error 03 trash not empty after emptying" >> "$emptying_log"
	echolor red ":: ERROR: Trash did not empty completely. ““$(eza -1a "$trash_dir" | wc -l)”” files left."
	return
    }
    echo -n > "$trash_manifest"
    echolor yellow ":: Trash manifest cleared."
    echolor yellow-white ":: Occupied memory before: ““$mem_before””"
    echolor yellow-white ":: Occupied memory after:  ““$(df | grep ' /$' | awk '{print $5}')””"
    unset IFS
}

manifest-log
safety-checks
[[ "$safe_check" -ne 8 ]] && {
    echo "error 01 security check fail with score $safe_check" >> "$emptying_log" 
    echolor red ":: ERROR: Safety checks have failed. Exiting."
    exit
}
visual-check
[[ "$visual_p" = "$trash_size" ]] || {
    echo "error 02 visual check fail with confirmation string $visual_p instead of $trash_size" >> "$emptying_log" 
    echolor red ":: ERROR: Visual check has failed. Exiting."
    exit
}
empty-trash
