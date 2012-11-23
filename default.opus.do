ALBUM=`grep ^album < default.vorbiscomment | cut -d'=' -f2`
GENRE=`grep ^genre < default.vorbiscomment | cut -d'=' -f2`
LICENSE=`grep ^license < default.vorbiscomment | cut -d'=' -f2`

ARTIST=`grep ^artist < $2.vorbiscomment | cut -d'=' -f2`
TITLE=`grep ^title < $2.vorbiscomment | cut -d'=' -f2`
DATE=`grep ^date < $2.vorbiscomment | cut -d'=' -f2`
DESCRIPTION=`grep ^description < $2.vorbiscomment | cut -d'=' -f2`
TRACKNUMBER=`grep ^tracknumber < $2.vorbiscomment | cut -d'=' -f2`

sox $2.input.mp3 -t wav - `cat SOX_OPTIONS` | \
     opusenc \
         --artist "$ARTIST" \
         --title "$TITLE" \
         --comment ALBUM="$ALBUM" \
         --comment DATE="$DATE" \
         --comment DESCRIPTION="$DESCRIPTION" \
         --comment GENRE="$GENRE" \
         --comment LICENSE="$LICENSE" \
         --comment TRACKNUMBER="$TRACKNUMBER" \
         --bitrate 40 --speech - $3
