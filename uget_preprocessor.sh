#!/bin/bash
# uGet_category_selection   script originally by fehhh & Michael Tunnell
# Rewritten with case statements and expanded MIME parsing by Steven Saus

# Declarations
URL=""
FILENAME=""
REFERER=""
COOKIES=""
CATEGORY=""
MAINDIR=""
SUGGESTEDFN=""

function call_uget {

    uget-gtk "$REFERER" "$COOKIES" "$FILENAME" "$URL" "$CATEGORY"
}

# Used when application/octet-stream or just major mimetype of application that
# doesn't match one of the things we've set up.
# Much easier to parse in bash than Windows, let me tell you.
function match_ext() {

    if echo "$extension" | egrep -i -e '\.(torrent|magnet)'; then
        CATEGORY="--category-index=6"
    elif echo "$extension" | egrep -i -e '\.(iso|img|cue)'; then
        CATEGORY="--category-index=1"
    elif echo "$extension" | egrep -i -e '\.(7z|zip|tar|gz|rar|arj|bz2|tgz|xz)'; then
        CATEGORY="--category-index=1"
    elif echo "$extension" | egrep -i -e '\.(doc|docx|xls|xlsx|odt|odf|css|html|djvu|rtf|csv|tsv|pdf|epub|azw|kf8|css|csv|djvu|vcf|md)'; then
        CATEGORY="--category-index=2"
    elif echo "$extension" | egrep -i -e '\.(avi|mov|m4v|mpg|mpeg|flv|mkv|wmv|mp4)'; then
        CATEGORY="--category-index=3"
    elif echo "$extension" | egrep -i -e '\.(mp3|midi|mod|s3m|wav|ogg|m3u|pls|flac|ape|m4a)'; then
        CATEGORY="--category-index=4"
    elif echo "$extension" | egrep -i -e '\.(apk|pup|pet|ebuild|appx|appxbundle|deb|rpm|yum|msi|bin|exe)'; then
        CATEGORY="--category-index=1"
    elif echo "$extension" | egrep -i -e '\.(xcf|gif|jpg|jpeg|svg|png|tiff|tif|ico|pbm|pcx)'; then
        CATEGORY="--category-index=5"
    else
        CATEGORY="--category-index=0"
    fi
}


function show_help {

echo -e "\n -u [URL] -f [FILENAME] -r [REFERRER] -c [COOKIEFILE] \n\n" \
    "See the README about setting up categories in uGet \n"\
    "Designed to be used with the Download with WGet extension \n"\   
    "Category sorting complements that of what is built into uGet now. \n"\ 
    "Works with Firefox Quantum \n"\
    "-h shows this help message\n"
}


# If you're reading along, we start here.
# Wget getting info about file types

function main_match {

    DINFO=$(wget --spider "$URL" 2>&1)
    mimetype=$(echo "$DINFO"|egrep -e '^Length:'|awk -F "[" '{print $2}'|awk -F "]" '{print $1}')
    mainmimetype=$(echo "$mimetype"|awk -F "/" '{print $1}')
    fileurl=$(echo "$DINFO"|egrep -e '^--'|awk -F " " '{print $3}')
    file=$(basename $fileurl)
    urlextension=${file##*.}
    
    # Logic: If there's a suggested filename, and they don't match, see if the URL based
    # extension is matched by one of our known extensions. If not, then use the suggested
    # filename.  Otherwise, use the URL based one.
    
    if [ -n "$SUGGESTEDFN" ];then
        extension2=${SUGGESTEDFN##*.}
        if [ "$urlextension" != "$extension2" ];then
            if echo "$urlextension" | egrep -i -e '\.(torrent|magnet|iso|img|cue|7z|zip|tar|gz|rar|arj|bz2|tgz|xz|doc|docx|xls|xlsx|odt|odf|css|html|djvu|rtf|csv|tsv|pdf|epub|azw|kf8|css|csv|djvu|vcf|md|avi|mov|m4v|mpg|mpeg|flv|mkv|wmv|mp4|mp3|midi|mod|s3m|wav|ogg|m3u|pls|flac|ape|m4a|apk|pup|pet|ebuild|appx|appxbundle|deb|rpm|yum|msi|bin|exe|xcf|gif|jpg|jpeg|svg|png|tiff|tif|ico|pbm|pcx)'; then
                extension=$(echo "$urlextension")
            else
                extension=$(echo "$extension2")
            fi
        fi
    else
        extension=$(echo "$urlextension")
    fi

    # Matching main mime type first, failing that, the minor mimetype, 
    # then failing that, the extension matching.

    case "$mainmimetype" in
        "text")
            CATEGORY="--category-index=2"
        ;;
        "video")
            CATEGORY="--category-index=3"
        ;;
        "audio")
            CATEGORY="--category-index=4"
        ;;
        "images")
            CATEGORY="--category-index=5"
        ;;
        *)
            #Now for the if-elif stuff
            if echo "$mimetype" | egrep -e 'application\/x.bittorrent'; then
                CATEGORY="--category-index=6"
            elif echo "$mimetype" | egrep -e 'application\/x-cd-image'; then
                CATEGORY="--category-index=1"
            elif echo "$mimetype" | egrep -e 'application\/(x.bzip2|x.gzip|x.tar|x.7z|rar|zip|x.bzip|x.gtar|x.compressed|lha|x.lha|x.compress|a.gzip|x.gunzip)'; then
                CATEGORY="--category-index=1"
            elif echo "$mimetype" | egrep -e 'application\/(vnd.ms.powerpoint|vnd.ms.excel|x.excel|x.ms.excel|vnd.oasis.opendocument.text|vnd.opendocument.spreadsheet|vnd.oasis.opendocument.presentation|vnd.oasis.opendocument.graphics|pdf|msword|x.rtf|mswrite|x-wri|rtf|vnd.ms.project|x.mspowerpoint|powerpoint|vnd.djvu|xml|epub+zip|vnd.amazon.ebook|x.mobipocket.ebook)'; then
                CATEGORY="--category-index=2"
            elif echo "$mimetype" | egrep -e 'application\/(x.debian.package|x.redhat.package.manager|x.rpm|x.msi)'; then
                CATEGORY="--category-index=1"
            elif echo "$mimetype" | egrep -e 'application\/octet.stream'; then
                match_ext
            else
                match_ext
            fi
        ;;
    esac
}


# The base uGet category is considered the "Home" category and used to determine the default d/l location for stripping off that path.
HOMEDIR=$(grep $HOME/.config/uGet/category/0000.json -e "folder" | awk -F '"' '{print $4"/"}' | sed -e 's/\\//g')


while getopts "u:f:r:c:h" opt; do
    case $opt in
        u)  URL=$(echo "$OPTARG")
            ;;
        f)  tempfilename=$(echo "$OPTARG")
            SUGGESTEDFN=${tempfilename#${HOMEDIR}}
            FILENAME=$(echo "--filename=$SUGGESTEDFN")
            ;;
        r)  REFERER=$(echo "--http-referer=$OPTARG")
            ;;
        c)  COOKIES=$(echo "--http-cookie-file=$OPTARG")
            ;;
        h)  show_help
            exit
            ;;        
    esac
done

#for backwards compatibility

if [ -z "$URL" ];then
    URL="$1"
fi

main_match

if [ -z "$URL" ];then
    show_help
    exit
else
    call_uget
fi
