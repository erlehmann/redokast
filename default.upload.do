redo-ifchange $2

exec >&2  # redirect stdout to stderr
ftp -vi dieweltistgarnichtso.net << EOF
cd hosts/warumnicht.dieweltistgarnichtso.net
hash
put $2
bye
