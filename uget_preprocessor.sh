    #!/bin/bash
    # uGet_category_selection  script by fehhh & Michael Tunnell
    # With a small tweak by Steven Saus
    # USAGE: For when you want to use uGet, but certain applications (cough liferea cough) don't support it.
    # Because KGet (etc) want the URL first, but uGet wants options first.
	# Please see the README for how to set up uGet properly

    #Getting info about file types
    DINFO=$(wget --spider "$1" 2>&1)

    #Selecting category
    if echo "$DINFO" | egrep -e 'application\/x.bittorrent'; then
        uget-gtk $2 $1 --category-index=6
    elif echo "$DINFO" | egrep -e 'application\/x-cd-image'; then
        uget-gtk $2 $1 --category-index=7
    elif echo "$DINFO" | egrep -e 'application\/(x.bzip2|x.gzip|x.tar|x.7z|rar|zip)'; then
        uget-gtk $2 $1 --category-index=1
    elif echo "$DINFO" | egrep -e '(application|image|text)\/(pdf|msword|rtf|vnd.ms.excel|vnd.djvu|plain)'; then
        uget-gtk $2 $1 --category-index=2
    elif echo "$DINFO" | egrep -e 'application\/octet.stream'; then
    #For octet
                if echo "$1" | egrep -i -e '\.torrent'; then
                      uget-gtk $2 $1 --category-index=6
                elif echo "$1" | egrep -i -e '\.(iso|img)'; then
                      uget-gtk $2 $1 --category-index=7
                elif echo "$1" | egrep -i -e '\.(bz2|gz|tgz|tar|rar|zip|7z)'; then
                      uget-gtk $2 $1 --category-index=1
                elif echo "$1" | egrep -i -e '\.(doc|docx|rtf|xls|xlsx|pdf|djvu|txt|ppt|pptx)'; then
                      uget-gtk $2 $1 --category-index=2
                elif echo "$1" | egrep -i -e '\.(avi|flv|mp4|wmv|mpg|mpeg|mkv)'; then
                      uget-gtk $2 $1 --category-index=3
                elif echo "$1" | egrep -i -e '\.(mp3|flac|ogg|ape|m4a)'; then
                      uget-gtk $2 $1 --category-index=4
                elif echo "$1" | egrep -i -e '\.deb'; then
                      uget-gtk $2 $1 --category-index=5
                elif echo "$1" | egrep -i -e '\.(gif|jpg|jpeg|png|tiff|tif|ico|pbm|pcx)'; then
                      uget-gtk $2 $1 --category-index=8
                else
                      uget-gtk $2 $1 --category-index=0
                fi
    elif echo "$DINFO" | egrep -e 'application\/x.debian.package'; then
            uget-gtk $2 $1 --category-index=5
    elif echo "$DINFO" | egrep -e 'video\/(x.flv|mp4|x.msvideo|x.ms.wmv|mpeg|x.matroska)'; then
            uget-gtk $2 $1 --category-index=3
    elif echo "$DINFO" | egrep -e 'audio\/(mpeg|mpeg3|flac)'; then
            uget-gtk $2 $1 --category-index=4
    elif echo "$DINFO" | egrep -e 'image'; then
        uget-gtk $2 $1 --category-index=8            
    else
    uget-gtk $2 $1 --category-index=0
    fi
