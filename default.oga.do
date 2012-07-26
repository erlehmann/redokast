redo-ifchange $2.vorbiscomment

test ! -e $2.oga && sox $2.input.mp3 -t wav - `cat SOX_OPTIONS` | oggenc -q 1 - -o $3
test -e $2.oga && cp $2.oga $3

cat default.vorbiscomment $2.vorbiscomment | vorbiscomment -w $3
