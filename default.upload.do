redo-ifchange $1

exec >&2  # redirect stdout to stderr
ftp -vi dieweltistgarnichtso.net << EOF
cd hosts/warumnicht.so
hash
put $1
bye
