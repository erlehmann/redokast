for f in `ls -1 *.input.* | sed 's/\(.*\)\.input.*/\1/'`; do
redo-ifchange $f.html $f.linklist-html
ALBUM=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^album=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
ARTIST=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^artist=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
done

BASEURL=`cat BASEURL`
BASEDATE=`cat BASEDATE`
TAG=`echo $BASEURL | sed 's/http:\/\//tag:/'`,$BASEDATE:feed.atom
NOW=`date +%Y-%m-%dT%H:%M:%SZ`

cat << EOF >> $3
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
    <title>$ALBUM</title>
    <id>$TAG</id>
    <author>
        <name>$ARTIST</name>
    </author>
    <link rel="self" href="$BASEURL/feed.atom"/>
    <updated>$NOW</updated>
EOF

for f in `ls --reverse -1 *.html | sed 's/\(.*\)\..*/\1/'`; do
test "$f" = "index" || DATE=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
test "$f" = "index" || DESCRIPTION=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^description=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
test "$f" = "index" || TITLE=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^title=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
test "$f" = "index" || LINKLIST=`cat $f.linklist-html`

test "$f" = "index" || OGALENGTH=`du -b $f.oga | cut -f1`
test "$f" = "index" || MP3LENGTH=`du -b $f.mp3 | cut -f1`

test "$f" = "index" || TAG=`echo $BASEURL | sed 's/http:\/\//tag:/'`,$DATE:$f
test "$f" = "index" || UPDATED=`date +%Y-%m-%dT%H:%M:%SZ -d$DATE`

test "$f" = "index" || cat << EOF >> $3
<entry>
    <title>$TITLE</title>
    <id>$TAG</id>
    <link rel="alternate" type="text/html" href="$BASEURL/$f.html"/>
    <link rel="enclosure" type="audio/ogg" href="$BASEURL/$f.oga" length="$OGALENGTH"/>
    <link rel="enclosure" type="audio/mpeg" href="$BASEURL/$f.mp3" length="$MP3LENGTH"/>
    <summary>$DESCRIPTION</summary>
    <content type="html">
        <![CDATA[
$LINKLIST
        ]]>
    </content>
    <updated>$UPDATED</updated>
</entry>
EOF
done

cat << EOF >> $3
</feed>
EOF
