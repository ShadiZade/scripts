#!/bin/bash 

bd () {
    date +"%Y-%m-%d %H-%M"
}

echo ":: Backing booklist..."
echo ""

precount_tbr=$(cat ~/Misc/Backups/my-books/tbr.txt  | wc -l)
precount_2022=$(cat ~/Misc/Backups/my-books/read-2022.txt  | wc -l)
precount_2021=$(cat ~/Misc/Backups/my-books/read-2021.txt  | wc -l)
precount_2020=$(cat ~/Misc/Backups/my-books/read-2020.txt  | wc -l)
precount_2019=$(cat ~/Misc/Backups/my-books/pre-2019.txt  | wc -l)

find ~/Books -maxdepth 1 -type f | sort | cut -c17- > ~/Misc/Backups/my-books/tbr.txt && echo ":: TBR success!" 
ls -1 ~/Books/read\ 2022 > ~/Misc/Backups/my-books/read-2022.txt && echo ":: Read 2022 success!" 
ls -1 ~/Books/read\ 2021 > ~/Misc/Backups/my-books/read-2021.txt && echo ":: Read 2021 success!" 
ls -1 ~/Books/read\ 2020 > ~/Misc/Backups/my-books/read-2020.txt && echo ":: Read 2020 success!" 
ls -1 ~/Books/pre-2019 > ~/Misc/Backups/my-books/pre-2019.txt && echo ":: Pre-2019 success!" 

postcount_tbr=$(cat ~/Misc/Backups/my-books/tbr.txt  | wc -l)
postcount_2022=$(cat ~/Misc/Backups/my-books/read-2022.txt  | wc -l)
postcount_2021=$(cat ~/Misc/Backups/my-books/read-2021.txt  | wc -l)
postcount_2020=$(cat ~/Misc/Backups/my-books/read-2020.txt  | wc -l)
postcount_2019=$(cat ~/Misc/Backups/my-books/pre-2019.txt  | wc -l)

echo ""
echo added $(calc "$postcount_tbr - $precount_tbr") to TBR "for a total of $postcount_tbr" \
|| echo "\033[31mWARNING: Failure to read TBR count!"
echo added $(calc "$postcount_2022 - $precount_2022") to Read 2022 "for a total of $postcount_2022" \
|| echo "\033[31mWARNING: Failure to read 2022 count!"
echo added $(calc "$postcount_2021 - $precount_2021") to Read 2021 "for a total of $postcount_2021" \
|| echo "\033[31mWARNING: Failure to read 2021 count!"
echo added $(calc "$postcount_2020 - $precount_2020") to Read 2020 "for a total of $postcount_2020" \
|| echo "\033[31mWARNING: Failure to read 2020 count!"
echo added $(calc "$postcount_2019 - $precount_2019") to Pre-2019 "for a total of $postcount_2019" \
|| echo "\033[31mWARNING: Failure to read 2019 count!"
echo "for a grand total of" $(calc "$postcount_tbr + $postcount_2022 + $postcount_2021 + $postcount_2020 + $postcount_2019") \
"(double check: $(fd 'pdf|epub|mobi' ~/Books | wc -l))" \
|| echo "\033[31mWARNING: Failure to read total count!"

echo ""
echo ":: Booklist backed successfully! Committing to git..."
cd ~/Misc/Backups/my-books/ || echo "\033[31mWARNING: Failure to go to backup directory!" || exit
git add . || echo "\033[31mWARNING: Failure to add to git!" || exit
echo ""
git commit -m "update booklist $(bd)" 
cd - > /dev/null || echo "\033[31mWARNING: Failure to return to previous directory!" || exit
echo ""
echo ":: Done!"
