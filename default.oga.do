sox $1.input.mp3 -t wav -|oggenc -q 1 - -o $3
cat default.vorbiscomment $1.vorbiscomment | vorbiscomment -w $3
