for f in `ls -1 *.input.* | sed 's/\(.*\)\.input.*/\1/'`; do
redo-ifchange $f.html
ALBUM=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^album=).*$'`
done

redo-ifchange feed.atom

cat << EOF >> $3
<!DOCTYPE html>
<meta charset=utf-8>
<title>$ALBUM</title>
<link rel=alternate type=application/atom+xml href=feed.atom>
<link rel=stylesheet href=style.css>

<h1>$ALBUM</h1>

<section>
    <h1>Folgen</h1>
    <ul>
EOF

for f in `ls --reverse -1 *.html | sed 's/\(.*\)\..*/\1/'`; do
test "$f" = "index" || TRACKNUMBER=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^tracknumber=).*$'`
test "$f" = "index" || DATE=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
test "$f" = "index" || DESCRIPTION=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^description=).*$'`
test "$f" = "index" || cat << EOF >> $3
        <li><a href="$f.html">Folge $TRACKNUMBER vom `date +%-d.%-m.%Y -d$DATE`</a> — $DESCRIPTION</li>
EOF
done

cat << EOF >> $3
    </ul>
</section>
EOF
