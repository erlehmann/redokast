for f in `ls -1 *.input.* | sed 's/\(.*\)\.input.*/\1/'`; do
    echo $f.oga.upload
    echo $f.opus.upload
    echo $f.mp3.upload
    echo $f.webvtt.upload
    echo $f.html.upload
done | xargs redo-ifchange

redo-ifchange index.html.upload feed.atom.upload style.css.upload media-fragments-html-polyfill.js.upload linklist.js.upload
