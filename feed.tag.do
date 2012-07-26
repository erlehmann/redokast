test ! -e $2.tag && {
    echo `cat BASEURL | sed 's/http:\/\//tag:/'`,`cat BASEDATE`:feed.atom
} || {
    cat $2.tag
}
