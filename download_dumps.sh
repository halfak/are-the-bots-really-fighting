#!/bin/bash

declare -a langs=("de" "en" "es" "fr" "ja" "pt" "zh" "ar" "he" "hu" "ko" "ro" "fa" "cz" "ru" "meta" "simple")
declare -a dump_date="20170420"
declare -a dump_folder="/data/wikipedia/xmldatadumps/public"
declare -a dump_mirror="https://dumps.wikimedia.your.org"

for i in "${langs[@]}"; do
    mkdir "$dump_folder"/"$i"wiki
    mkdir "$dump_folder"/"$i"wiki/"$dump_date"

    echo Downloading "$i"wiki_"$dump_date"
    wget -O "$dump_folder"/"$i"wiki/"$dump_date"/"$i"wiki-"$dump_date"-sha1sums.txt "$dump_mirror"/"$i"wiki/"$dump_date"/"$i"wiki-"$dump_date"-sha1sums.txt
    cat "$dump_folder"/"$i"wiki/"$dump_date"/"$i"wiki-"$dump_date"-sha1sums.txt | grep stub-meta-history | head -n -1 | awk '{ print $2; }' > "$i"wiki_"$dump_date"_to_download.txt

    cat "$i"wiki_"$dump_date"_to_download.txt | while read LINE
    do
        echo     Downloading $LINE
        wget -nc -O "$dump_folder"/"$i"wiki/"$dump_date"/"$LINE" "$dump_mirror"/"$i"wiki/"$dump_date"/"$LINE"
    done

done
