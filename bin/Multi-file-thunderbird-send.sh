for ((i=1;i<=15;i++));
do	printf -v f "Kunstgeschichte.7z.%03d" $i
	echo "File=$f"
	[ -f "$f" ] && thunderbird-compose "Kunstgeschichte part $i of 15" "kim.poinsignon@gmail.com" "Dies ist Teil $i von 15 der gezippten Datei." "$f"
done 
