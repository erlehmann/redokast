# ensure audio file has been created
redo-ifchange $1.oga

ALBUM=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^album=).*$'`
DATE=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`

cat << EOF >> $3
<!DOCTYPE html>
<meta charset=utf-8>
<title>$TITLE</title>
<link rel=stylesheet href=style.css>

<hgroup>
    <h1>$ALBUM</h1>
    <h2>Folge $TRACKNUMBER vom `date +%-d.%-m.%Y -d$DATE`</h2>
</hgroup>

<audio controls>
    <source src="$1.oga">
    <a href="$1.oga">Download: <i>$1.oga</i></a>
</audio>

<section>
    <h1>Beschreibung</h1>
EOF

cat $1.description >> $3

cat << EOF >> $3
</section>
<section>
    <h1>Linkliste</h1>
    <section>
EOF

cat $1.linklist >> $3

cat << EOF >> $3
    </section>
</section>

<footer>
    Footertext.
</footer>
EOF
