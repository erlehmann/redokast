ALBUM=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^album=).*$'`
TITLE=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^title=).*$'`
ARTIST=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^artist=).*$'`
DESCRIPTION=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^description=).*$'`
GENRE=`vorbiscomment -l $1.oga|grep --only-matching --perl-regexp '(?<=^genre=).*$'`

lame --strictly-enforce-ISO --abr 80 $1.input.mp3 $3
id3v2 -t "$TITLE" -c "$DESCRIPTION" -a "$ARTIST" -A "$ALBUM" -g "$GENRE" $3
