# ensure audio file and link list have been created
redo-ifchange $2.oga $2.mp3 $2.linklist

./validate-links.py < $2.linklist

ALBUM=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^album=).*$'`
DATE=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
DESCRIPTION=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^description=).*$'`
TRACKNUMBER=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^tracknumber=).*$'`

cat << EOF >> $3
<!DOCTYPE html>
<meta charset=utf-8>
<title>$ALBUM – Folge $TRACKNUMBER</title>
<link rel=stylesheet href=style.css>
<script src=domready.js></script>
<script src=linklist.js></script>

<hgroup>
    <h1>$ALBUM</h1>
    <h2>Folge $TRACKNUMBER vom `date +%-d.%-m.%Y -d$DATE`</h2>
</hgroup>

<figure>
    <audio controls>
        <source src="$2.oga">
        <source src="$2.mp3">
        <a href="$2.oga">Download: <i>$2.oga</i></a>
        <a href="$2.mp3">Download: <i>$2.mp3</i></a>
    </audio>

    <figcaption>
        $DESCRIPTION
    </figcaption>
</figure>

<section>
<h1>Kapitel</h1>
<section>
EOF

./generate-chapterlist.py < $2.linklist >> $3

cat << EOF >> $3
</section>
</section>

<section>
<h1>Links</h1>
<section>
EOF

./generate-linklist.py < $2.linklist >> $3

cat << EOF >> $3
</section>
</section>

<footer>
    Diese Webseite wurde generiert durch <a href="https://github.com/erlehmann/redokast"><i>redokast</i></a>.
</footer>
EOF
