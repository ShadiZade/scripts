#!/bin/bash 

bd () {
    date +"%Y-%m-%d %H-%M"
}

echo ":: Backing booklist..."
echo ""

precount_2023=$(cat ~/Misc/Backups/ebook-library/read-2023.txt  | wc -l)
precount_2022=$(cat ~/Misc/Backups/ebook-library/read-2022.txt  | wc -l)
precount_2021=$(cat ~/Misc/Backups/ebook-library/read-2021.txt  | wc -l)
precount_2020=$(cat ~/Misc/Backups/ebook-library/read-2020.txt  | wc -l)
precount_2019=$(cat ~/Misc/Backups/ebook-library/pre-2019.txt  | wc -l)
precount_tbr=$(cat ~/Misc/Backups/ebook-library/tbr.txt  | wc -l)
precount_fix=$(cat ~/Misc/Backups/ebook-library/fix.txt  | wc -l)

ls -1 ~/Books/read\ 2023 > ~/Misc/Backups/ebook-library/read-2023.txt && echo ":: Read 2023 success!" 
ls -1 ~/Books/read\ 2022 > ~/Misc/Backups/ebook-library/read-2022.txt && echo ":: Read 2022 success!" 
ls -1 ~/Books/read\ 2021 > ~/Misc/Backups/ebook-library/read-2021.txt && echo ":: Read 2021 success!" 
ls -1 ~/Books/read\ 2020 > ~/Misc/Backups/ebook-library/read-2020.txt && echo ":: Read 2020 success!" 
ls -1 ~/Books/pre-2019 > ~/Misc/Backups/ebook-library/pre-2019.txt && echo ":: Pre-2019 success!" 
find ~/Books -maxdepth 1 -type f | sort | cut -c17- > ~/Misc/Backups/ebook-library/tbr.txt && echo ":: TBR success!" 
ls -1 ~/Books/fix > ~/Misc/Backups/ebook-library/fix.txt && echo ":: Fix success!" 

postcount_2023=$(cat ~/Misc/Backups/ebook-library/read-2023.txt  | wc -l)
postcount_2022=$(cat ~/Misc/Backups/ebook-library/read-2022.txt  | wc -l)
postcount_2021=$(cat ~/Misc/Backups/ebook-library/read-2021.txt  | wc -l)
postcount_2020=$(cat ~/Misc/Backups/ebook-library/read-2020.txt  | wc -l)
postcount_2019=$(cat ~/Misc/Backups/ebook-library/pre-2019.txt  | wc -l)
postcount_tbr=$(cat ~/Misc/Backups/ebook-library/tbr.txt  | wc -l)
postcount_fix=$(cat ~/Misc/Backups/ebook-library/fix.txt  | wc -l)

diff_2023=$(("$postcount_2023"-"$precount_2023"))
diff_2022=$(("$postcount_2022"-"$precount_2022"))
diff_2021=$(("$postcount_2021"-"$precount_2021"))
diff_2020=$(("$postcount_2020"-"$precount_2020"))
diff_2019=$(("$postcount_2019"-"$precount_2019"))
diff_tbr=$(("$postcount_tbr"-"$precount_tbr"))
diff_fix=$(("$postcount_fix"-"$precount_fix"))
grand_total=$(("$postcount_tbr"+"$postcount_2023"+"$postcount_2022"+"$postcount_2021"+"$postcount_2020"+"$postcount_2019"+"$postcount_fix"))
double_check="$(fd 'pdf|epub|mobi' ~/Books | sed '/add\//d' | wc -l)"

[ $diff_2023 -eq 0 ] || diff_2023="\033[31m$diff_2023\033[0m" 
[ $diff_2022 -eq 0 ] || diff_2022="\033[31m$diff_2022\033[0m" 
[ $diff_2021 -eq 0 ] || diff_2021="\033[31m$diff_2021\033[0m" 
[ $diff_2020 -eq 0 ] || diff_2022="\033[31m$diff_2020\033[0m" 
[ $diff_2019 -eq 0 ] || diff_2019="\033[31m$diff_2019\033[0m" 
[ $diff_tbr -eq 0 ] || diff_tbr="\033[31m$diff_tbr\033[0m" 
[ $diff_fix -eq 0 ] || diff_fix="\033[31m$diff_fix\033[0m" 

echo ""
echo -e "added $diff_2023 to Read 2023 for a total of \033[4;31m$postcount_2023\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read 2023 count!\033[0m"
echo -e "added $diff_2022 to Read 2022 for a total of \033[31m$postcount_2022\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read 2022 count!\033[0m"
echo -e "added $diff_2021 to Read 2021 for a total of \033[31m$postcount_2021\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read 2021 count!\033[0m"
echo -e "added $diff_2020 to Read 2020 for a total of \033[31m$postcount_2020\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read 2020 count!\033[0m"
echo -e "added $diff_2019 to Pre-2019 for a total of \033[31m$postcount_2019\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read 2019 count!\033[0m"
echo -e "added $diff_tbr to TBR for a total of \033[31m$postcount_tbr\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read TBR count!\033[0m"
echo -e "added $diff_fix to Fix for a total of \033[31m$postcount_fix\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read Fix count!\033[0m"
echo -e "for a grand total of \033[31m$grand_total\033[0m" \
|| echo -e "\033[33mWARNING: Failure to read total count!\033[0m"
[ $grand_total -eq $double_check ] || echo -e "\033[33mWARNING: Double check failed! ($grand_total vs. $double_check)\033[0m"

echo ""
echo ":: Booklist backed successfully! Committing to git..."
cd ~/Misc/Backups/ebook-library/ || echo -e "\033[33mWARNING: Failure to go to backup directory!\033[0m" || exit
git add . || echo -e "\033[33mWARNING: Failure to add to git!\033[0m" || exit
echo ""
git commit -m "update booklist $(bd)" 
cd - > /dev/null || echo -e "\033[33mWARNING: Failure to return to previous directory!\033[0m" || exit
echo ""
echo ":: Done!"
