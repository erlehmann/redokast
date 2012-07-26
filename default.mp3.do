redo-ifchange $2.vorbiscomment

ALBUM=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^album=).*$'`
TITLE=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^title=).*$'`
ARTIST=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^artist=).*$'`
DESCRIPTION=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^description=).*$'`
GENRE=`vorbiscomment -l $2.oga|grep --only-matching --perl-regexp '(?<=^genre=).*$'`

test ! -e $2.mp3 && pv -pte $2.input.mp3 | sox -t mp3 - -t wav - `cat SOX_OPTIONS` | lame --strictly-enforce-ISO -q 0 -V 7.5 - $3
test -e $2.mp3 && cp $2.mp3 $3

id3v2 -t "$TITLE" -c "$DESCRIPTION" -a "$ARTIST" -A "$ALBUM" -g "$GENRE" $3
