test ! -e $2.tag && {
    DATE=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
    echo `cat BASEURL | sed 's/http:\/\//tag:/'`,$DATE:$2
} || {
    cat $2.tag
}
