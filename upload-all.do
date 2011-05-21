for f in `ls -1 *.input.* | sed 's/\(.*\)\.input.*/\1/'`; do
    echo $f.html.upload
    echo $f.oga.upload
done | xargs redo-ifchange

#redo-ifchange index.html.upload
