##############################################################
#
# download_dumps.sh: script for downloading MediaWiki
# metadata dumps from the Wikimedia Foundation servers
#
# Note that the Wikimedia foundation only keeps
# specific versions of dumps for about six months,
# so the April 20th, 2017 dumps we used have now
# been removed. This script will no longer work as-is.
#
# This script, which we used to download the dumps from
# dumps.wikimedia.org or a mirror, is here for purposes
# of computational reproducibility and replayability. You
# can change the variables below to automatically download
# newer dumps in various languages.
#
# We have also archived the April 20th, 2017 dumps we used
# for this project at https://doi.org/10.6078/D1FD3K via
# the University of California Library's DASH project.
# You must click a link in a browser, enter your e-mail,
# and a link will be sent to you so you can download the
# older dumps.
#
##############################################################


#!/bin/bash

declare -a langs=("de" "en" "es" "fr" "ja" "pt" "zh")
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
