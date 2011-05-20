INLIST=false

cat $1.linklist | while read LINE; do
    LINEMARKER=`echo $LINE | grep --only-matching --perl-regexp '^....(?= )' || echo`
    test "$LINEMARKER" = "HTML" && test "$INLIST" = "true" && echo '    </ol>' >> $3
    test "$LINEMARKER" = "HTML" && HTML=`echo $LINE | grep --only-matching --perl-regexp '(?<=^.... ).*$'`
    test "$LINEMARKER" = "HTML" && echo \ \ \ \ $HTML >> $3
    test "$LINEMARKER" = "HTML" && INLIST=false && continue

    TIMECODE=`echo $LINE | grep --only-matching --perl-regexp ^.*:..(?= \<)`
    URL=`echo $LINE | grep --only-matching --perl-regexp '(?<= \<).*:.*(?=\> )'`;
    TEXT=`echo $LINE | grep --only-matching --perl-regexp '(?<=\> ).*$'`
    test "$INLIST" = "false" && echo '    <ol>' >> $3
    cat << EOF >> $3
        <li id="$TIMECODE">
            <a class="timecode" href="#$TIMECODE">$TIMECODE</a>
            <a href="$URL">$TEXT</a>
        </li>
EOF
    INLIST=true
done

cat << EOF >> $3
    </ol>
EOF
