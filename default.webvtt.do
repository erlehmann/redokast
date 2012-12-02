redo-ifchange $2.oga $2.linklist
LENGTH=`oggz-info $2.oga | grep Content-Duration | cut -d' ' -f2`
./generate-webvtt.py "$LENGTH" < $2.linklist
