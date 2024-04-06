#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

trash_dir="$HOME/.local/share/Trash/files"
trash_manifest="$HOME/.local/share/Trash/deletetimes"
log_dir="$HOME/.local/logs/trash"
current_time="$(formatted-date-string)"
trash_size="$(du -sh "$trash_dir" | awk '{print $1}')"

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
    touch "$log_dir"/emptying/emptying-"$current_time"
}

function safety-checks {
    safe_check=0
    echolor green ":: Running safety checks..."
    echolor green ":: ““[1/6]”” Trash directory definition is not empty... " 1
    [[ -z "$trash_dir" ]] && {
	echolor red "[FAIL]"
    } || {
	echolor white "[PASS]"
	((safe_check++))
    }
    echolor green ":: ““[2/6]”” Trash directory definition contains the word 'trash'... " 1
    echo -n "$trash_dir" | grep -qi "trash" && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[3/6]”” Trash directory exists... " 1
    [[ -d "$trash_dir" ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }	
    echolor green ":: ““[4/6]”” Trash manifest exists... " 1
    [[ -e "$trash_manifest" ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[5/6]”” Trash manifest has been backed up... " 1
    [[ -e "$log_dir"/manifests/manifest-"$current_time" ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[6/6]”” Trash directory is not empty... " 1
    [[ "$(eza -1a "$trash_dir" | wc -l )" -gt 0 ]] && {
	echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green ":: ““[7/7]”” Emptying log file exists... " 1
    [[ -e "$log_dir/emptying/emptying-$current_time" ]] && {
		echolor white "[PASS]"
	((safe_check++))
    } || {
	echolor red "[FAIL]"
    }
    echolor green-purple ":: Safety score is ““${safe_check}”” out of 7"
    export safe_check
}


function visual-check {
    echolor purple ":: Give the information a visual once-over to confirm nothing has gotten past the code."
    echolor purple ":: Trash directory: ““$trash_dir””"
    echolor purple ":: Trash manifest: ““$trash_manifest””"
    echolor purple ":: Number of files in trash: ““$(eza -1a "$trash_dir" | wc -l)””"
    echolor purple ":: Trash directory size: ““$trash_size””"
}


function empty-trash {
    files_deleted=0
    cd "$trash_dir"
    echolor yellow ":: Emptying trash..."
    IFS=$'\n'
    for j in $(eza -1a --no-quotes "$trash_dir"); do
	[[ -z "$j" ]] && {
	    echolor red ":: FATAL ERROR: Script attempted to delete an nonexistent file"
	    echolor red ":: Crashing out, standing by to avoid causing damage. ““$files_deleted”” files already deleted."
	    echolor red ":: Info:"
	    echolor red "\t- File name (should be empty): ““$j””"
	    
	}
	[[ -e "$trash_dir"/"$j" ]] || {
	    echolor red ":: FATAL ERROR: Script attempted to delete file ““$j””, which doesn't exist inside trash"
	    echolor red ":: Crashing out, standing by to avoid causing damage. ““$files_deleted”” files already deleted."
	    echolor red ":: Info:"
	    echolor red "\t- Real path: ““$(realpath "$j")””"
	    echolor red "\t- Base name: ““$(basename "$j")””"
	    echolor red "\t- Appearance in eza: ““$(eza -1a --no-quotes "$trash_dir" | grep "$j")””"
	    echolor red "\t- Safety search pattern: ““$trash_dir/$j””"
	    return
	}
#	rm -rf "$trash_dir/$j"
	((files_deleted++))
	previously_deleted="$j"
    done
    echolor yellow-purple ":: Done. Deleted ““$files_deleted”” files."
}


manifest-log
safety-checks
[[ "$safe_check" -ne 7 ]] && {
    echolor red ":: ERROR: Safety checks have failed. Exiting."
    exit
}
visual-check
empty-trash
