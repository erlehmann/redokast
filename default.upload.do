redo-ifchange $1

exec >&2  # redirect stdout to stderr
ftp -vi dieweltistgarnichtso.net << EOF
cd hosts/warumnicht.dieweltistgarnichtso.net
hash
put $1
bye
