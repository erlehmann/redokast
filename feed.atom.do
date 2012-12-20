for f in `ls -1 *.input.* | sed 's/\(.*\)\.input.*/\1/'`; do
redo-ifchange $f.html $f.opus $f.oga $f.mp3 $f.webvtt $f.linklist-html $f.vorbiscomment
ALBUM=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^album=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
done

BASEURL=`cat BASEURL`
BASEDATE=`cat BASEDATE`
NOW=`date +%Y-%m-%dT%H:%M:%SZ`

redo-ifchange feed.tag

cat << EOF >> $3
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
 <title>$ALBUM</title>
 <id>`cat feed.tag`</id>
 <link rel="self" href="$BASEURL/feed.atom"/>
 <updated>$NOW</updated>
EOF

for f in `ls -1 *.html | sort -t '-' -nk 2 --reverse | sed 's/\(.*\)\..*/\1/'`; do
test "$f" = "index" ||  {
  redo-ifchange $f.tag

  ARTIST=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^artist=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
  DATE=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^date=).*$'`
  DESCRIPTION=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^description=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
  TITLE=`vorbiscomment -l $f.oga|grep --only-matching --perl-regexp '(?<=^title=).*$' | sed 's/</\&lt;/g; s/>/\&gt;/g; s/\&/\&amp;/g;'`
  LINKLIST=`cat $f.linklist-html`

  OPUSLENGTH=`du -b $f.opus | cut -f1`
  OGALENGTH=`du -b $f.oga | cut -f1`
  MP3LENGTH=`du -b $f.mp3 | cut -f1`

  UPDATED=`date +%Y-%m-%dT%H:%M:%SZ -d$DATE`

  cat << EOF >> $3
<entry>
 <title>$TITLE</title>
 <id>`cat $f.tag`</id>
 <author>
  <name>$ARTIST</name>
 </author>
 <link rel="alternate" type="text/html" href="$BASEURL/$f.html"/>
 <link rel="enclosure" type="audio/ogg; codecs=opus" href="$BASEURL/$f.opus" length="$OPUSLENGTH"/>
 <link rel="enclosure" type="audio/ogg; codecs=vorbis" href="$BASEURL/$f.oga" length="$OGALENGTH"/>
 <link rel="enclosure" type="audio/mpeg" href="$BASEURL/$f.mp3" length="$MP3LENGTH"/>
 <link rel="chapters" type="text/vtt" href="$BASEURL/$f.webvtt"/>
 <summary>$DESCRIPTION</summary>
 <content type="html">
<![CDATA[
$LINKLIST
]]>
 </content>
 <updated>$UPDATED</updated>
</entry>
EOF
}

done

cat << EOF >> $3
</feed>
EOF
