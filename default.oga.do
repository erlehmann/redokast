sox $1.input.mp3 -t wav -|oggenc - -o $3
cat default.vorbiscomment $1.vorbiscomment | vorbiscomment -w $3
