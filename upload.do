redo-ifchange index.html
redo-ifchange feed.atom

exec >&2  # redirect stdout to stderr
ftp -vi dieweltistgarnichtso.net << EOF
cd hosts/warumnicht.so
mput `ls -1 *.html| tr '\n' ' '`
mput `ls -1 *.css| tr '\n' ' '`
mput `ls -1 *.js| tr '\n' ' '`
put feed.atom
bye
