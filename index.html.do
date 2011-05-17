for f in `ls -1 *.wav | sed 's/\(.*\)\..*/\1/'`; do
test "$f" = "index" || redo-ifchange $f.html
test "$f" = "index" || ALBUM=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^album=).*$'`
done

cat << EOF >> $3
<!DOCTYPE html>
<meta charset=utf-8>
<title>$ALBUM<title>

<h1>$ALBUM</h1>

<section>
    <h1>Was bisher geschah</h1>
    <ul>
EOF

for f in `ls -1 *.html | sed 's/\(.*\)\..*/\1/'`; do
test "$f" = "index" || TITLE=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^title=).*$'`
test "$f" = "index" || cat << EOF >> $3
        <li><a href="$f.html">$TITLE</a></li>
EOF
done

cat << EOF >> $3
    </ul>
<section>
EOF
