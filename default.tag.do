test ! -e $1.tag && {
    DATE=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
    echo `cat BASEURL | sed 's/http:\/\//tag:/'`,$DATE:$1
} || {
    cat $1.tag
}
