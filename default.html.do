# ensure audio file and link list have been created
redo-ifchange $1.oga $1.mp3 $1.linklist-html

ALBUM=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^album=).*$'`
DATE=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
DESCRIPTION=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^description=).*$'`
TRACKNUMBER=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^tracknumber=).*$'`

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
        <source src="$1.oga">
        <source src="$1.mp3">
        <a href="$1.oga">Download: <i>$1.oga</i></a>
        <a href="$1.mp3">Download: <i>$1.mp3</i></a>
    </audio>

    <figcaption>
        $DESCRIPTION
    </figcaption>
</figure>

<section>
    <h1>Linkliste</h1>
    <section>
EOF

cat $1.linklist-html >> $3

cat << EOF >> $3
    </section>
</section>

<footer>
    Diese Webseite wurde generiert durch <a href="https://github.com/erlehmann/redokast"><i>redokast</i></a>.
</footer>
EOF
