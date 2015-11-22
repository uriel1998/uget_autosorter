#!/bin/bash
# uGet_category_selection  script originally by fehhh & Michael Tunnell
# Rewritten with case statements and expanded MIME parsing by Steven Saus
#

# Used when application/octet-stream or just major mimetype of application that
# doesn't match one of the things we've set up.
# Much easier to parse in bash than Windows, let me tell you.
function match_ext() {
  if echo "$extension" | egrep -i -e '\.(torrent|magnet)'; then
    uget-gtk $2 $1 --category-index=6
  elif echo "$extension" | egrep -i -e '\.(iso|img|cue)'; then
    uget-gtk $2 $1 --category-index=7
  elif echo "$extension" | egrep -i -e '\.(7z|zip|tar|gz|rar|arj|bz2|tgz)'; then
    uget-gtk $2 $1 --category-index=1
  elif echo "$extension" | egrep -i -e '\.(doc|docx|xls|xlsx|odt|odf|css|html|djvu|rtf|csv|tsv|pdf|epub|azw|kf8)'; then
    uget-gtk $2 $1 --category-index=2
  elif echo "$extension" | egrep -i -e '\.(avi|mov|m4v|mpg|mpeg|flv|mkv|wmv|mp4)'; then
    uget-gtk $2 $1 --category-index=3
  elif echo "$extension" | egrep -i -e '\.(mp3|midi|mod|s3m|wav|ogg|m3u|pls|flac|ape|m4a)'; then
    uget-gtk $2 $1 --category-index=4
  elif echo "$extension" | egrep -i -e '\.(apk|pup|pet|ebuild|appx|appxbundle|deb|rpm|yum|msi)'; then
    uget-gtk $2 $1 --category-index=5
  elif echo "$extension" | egrep -i -e '\.(gif|jpg|jpeg|svg|png|tiff|tif|ico|pbm|pcx)'; then
    uget-gtk $2 $1 --category-index=8
  else
    uget-gtk $2 $1 --category-index=0
  fi
}


# If you're reading along, we start here.
# Wget getting info about file types
DINFO=$(wget --spider "$1" 2>&1)
mimetype=$(echo "$DINFO"|egrep -e '^Length:'|awk -F "[" '{print $2}'|awk -F "]" '{print $1}')
mainmimetype=$(echo "$mimetype"|awk -F "/" '{print $1}')
fileurl=$(echo "$DINFO"|egrep -e '^--'|awk -F " " '{print $3}')
file=$(basename $fileurl)
extension=${file##*.}
# need to put in check for if there's a passed suggested filename
# and see if those extensions match as an error check
# just in case it's a weird stream or something

case "$mainmimetype" in
  "text")
    uget-gtk $2 $1 --category-index=2
  ;;
  "video")
    uget-gtk $2 $1 --category-index=3
  ;;
  "audio")
    uget-gtk $2 $1 --category-index=4
  ;;
  "images")
    uget-gtk $2 $1 --category-index=8
  ;;
  *)
    #Now for the if-elif stuff
    if echo "$mimetype" | egrep -e 'application\/x.bittorrent'; then
      uget-gtk $2 $1 --category-index=6
    elif echo "$mimetype" | egrep -e 'application\/x-cd-image'; then
      uget-gtk $2 $1 --category-index=7
    elif echo "$mimetype" | egrep -e 'application\/(x.bzip2|x.gzip|x.tar|x.7z|rar|zip|x.bzip|x.gtar|x.compressed|lha|x.lha|x.compress|a.gzip|x.gunzip)'; then
      uget-gtk $2 $1 --category-index=1
    elif echo "$mimetype" | egrep -e 'application\/(vnd.ms.powerpoint|vnd.ms.excel|x.excel|x.ms.excel|vnd.oasis.opendocument.text|vnd.opendocument.spreadsheet|vnd.oasis.opendocument.presentation|vnd.oasis.opendocument.graphics|pdf|msword|x.rtf|mswrite|x-wri|rtf|vnd.ms.project|x.mspowerpoint|powerpoint|vnd.djvu|xml|epub+zip|vnd.amazon.ebook|x.mobipocket.ebook)'; then
      uget-gtk $2 $1 --category-index=2
    elif echo "$mimetype" | egrep -e 'application\/(x.debian.package|x.redhat.package.manager|x.rpm|x.msi)'; then
      uget-gtk $2 $1 --category-index=5
    elif echo "$mimetype" | egrep -e 'application\/octet.stream'; then
      match_ext
    else
      match_ext
    fi
  ;;
esac
