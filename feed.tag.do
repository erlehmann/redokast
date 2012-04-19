test ! -e $1.tag && {
    echo `cat BASEURL | sed 's/http:\/\//tag:/'`,`cat BASEDATE`:feed.atom
} || {
    cat $1.tag
}
