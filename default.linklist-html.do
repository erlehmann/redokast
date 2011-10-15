redo-ifchange $1.linklist
INLIST=false

exec >&2  # redirect stdout to stderr

cat $1.linklist | while read LINE; do
    LINEMARKER=`echo $LINE | grep --only-matching --perl-regexp '^....(?= )' || echo`
    test "$LINEMARKER" = "HTML" && test "$INLIST" = "true" && echo '    </ol>' >> $3
    test "$LINEMARKER" = "HTML" && HTML=`echo $LINE | grep --only-matching --perl-regexp '(?<=^.... ).*$'`
    test "$LINEMARKER" = "HTML" && echo \ \ \ \ $HTML >> $3
    test "$LINEMARKER" = "HTML" && INLIST=false && continue

    TIMECODE=`echo $LINE | cut -d " " -f1`
    URL=`echo $LINE | cut -d " " -f2 | tr -d "<>"`

    # check if http/https URLs are accessible
    echo -n .
    echo $URL | head -c4 | grep -q "http" && (
        curl -A "redokast/2011-10-15" -m 20 -Isk $URL | head -n1 | \
            egrep -q "200|301|302|401|405" || (
                echo; echo; echo "<$URL> is not accessible."
                echo; curl -A "redokast/2011-10-15" -m 20 -Isk $URL
                false
            )
    )

    TEXT=`echo $LINE | cut -d " " -f3-`
    test "$INLIST" = "false" && echo '    <ol>' >> $3
    cat << EOF >> $3
        <li id="$TIMECODE">
            <a class="timecode" href="#$TIMECODE">$TIMECODE</a>
            <a href="$URL">$TEXT</a>
        </li>
EOF
    INLIST=true
done

echo  # newline, necessary because of the dots

cat << EOF >> $3
    </ol>
EOF
