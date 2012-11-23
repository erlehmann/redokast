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
EOF

cat BASEDESCRIPTION >> $3

cat << EOF >> $3
    <h1>Folgen</h1>
    <ol class=episodes>
EOF

for f in `ls -1 *.html | sort -t '-' -nk 2 --reverse | sed 's/\(.*\)\..*/\1/'`; do
test "$f" = "index" || TRACKNUMBER=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^tracknumber=).*$'`
test "$f" = "index" || DATE=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
test "$f" = "index" || DESCRIPTION=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^description=).*$'`
test "$f" = "index" || cat << EOF >> $3
        <li><a href="$f.html">Folge $TRACKNUMBER vom `date +%-d.%-m.%Y -d$DATE`</a> — $DESCRIPTION
EOF
done

cat << EOF >> $3
    </ol>
</section>
EOF
