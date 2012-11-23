redo-ifchange $2.vorbiscomment

ALBUM=`grep ^album < default.vorbiscomment | cut -d'=' -f2`
GENRE=`grep ^genre < default.vorbiscomment | cut -d'=' -f2`

ARTIST=`grep ^artist < $2.vorbiscomment | cut -d'=' -f2`
TITLE=`grep ^title < $2.vorbiscomment | cut -d'=' -f2`
DESCRIPTION=`grep ^description < $2.vorbiscomment | cut -d'=' -f2`
TRACKNUMBER=`grep ^tracknumber < $2.vorbiscomment | cut -d'=' -f2`

test ! -e $2.mp3 && pv -pte $2.input.mp3 | sox -t mp3 - -t wav - `cat SOX_OPTIONS` | lame --strictly-enforce-ISO -q 0 -V 7.5 - $3
test -e $2.mp3 && cp $2.mp3 $3

id3v2 \
    -A "$ALBUM" \
    -g "$GENRE" \
    -T "$TRACKNUMBER" \
    -t "$TITLE" \
    -c "$DESCRIPTION" \
    -a "$ARTIST" \
    $3
