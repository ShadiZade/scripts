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
echo added $(calc "$postcount_tbr - $precount_tbr") to TBR || echo "WARNING: Failure to read TBR count!"
echo added $(calc "$postcount_2022 - $precount_2022") to Read 2022 || echo "WARNING: Failure to read 2022 count!"
echo added $(calc "$postcount_2021 - $precount_2021") to Read 2021 || echo "WARNING: Failure to read 2021 count!"
echo added $(calc "$postcount_2020 - $precount_2020") to Read 2020 || echo "WARNING: Failure to read 2020 count!"
echo added $(calc "$postcount_2019 - $precount_2019") to Pre-2019 || echo "WARNING: Failure to read 2019 count!"

echo ""
echo ":: Book list updated! Committing to git..."
cd ~/Misc/Backups/my-books/ || echo "WARNING: Failure to go to backup directory!" || exit
git add . || echo "WARNING: Failure to add to git!" || exit
echo ""
git commit -m "update booklist $(bd)" 
cd - > /dev/null || echo "WARNING: Failure to return to previous directory!" || exit
echo ""
echo ":: Done!"
