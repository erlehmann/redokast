oggenc $1.wav -o $3
cat default.vorbiscomment $1.vorbiscomment | vorbiscomment -w $3
