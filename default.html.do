# ensure audio file has been created
redo-ifchange $1.oga

TITLE=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^title=).*$'`
ARTIST=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^artist=).*$'`

cat << EOF >> $3
<!DOCTYPE html>
<meta charset=utf-8>
<title>$TITLE<title>

<style>
body, footer, hgroup, section { display: block; margin: 1em; }
body { margin: 1em auto; width: 34em; }
footer, h1, h2 { text-align: center; }
h1 { font-size: 2em; }
section > section > h1, h2 { font-size: 1.5em; }
</style>

<hgroup>
    <h1>$TITLE</h1>
    <h2>mit $ARTIST</h2>
</hgroup>

<audio>
    <source src="$1.oga">
    <a href="$1.oga">Download: <i>$1.oga</i></a>
</audio>

EOF

cat $1.description >> $3

cat << EOF >> $3
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
