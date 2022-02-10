#
# Start Blender via Console
#
# "BlenderProg" Variable contains full qualified path to the blender program.
# 
#------------------------------------------------------------------------------

#####BlenderProg=/opt/blender-2.77a-linux-glibc211-x86_64/blender
#~ 
#~ echo "Starting blender...($BlenderProg)"
#~ echo "------------------------------------------------------------------------"
#~ $BlenderProg
#~ echo "------------------------------------------------------------------------"
#~ echo "END."

echo "------------------------------------------------------------------------"
#echo "BlenderProg=[$BlenderProg]"
#nautilus /opt/
#gedit /home/kevin/.bashrc & 

#echo "$# Parameters, \@=[$@]"

if [ $# -eq 0 ];
then
	echo "BlenderProg=[$BlenderProg]"
else 
	while getopts oh opt
		do 
			case $opt in
				o) nautilus /opt/
				   gedit /home/kevin/.bashrc &
				;;
				h) echo "     show path to executable blender version."
				   echo "-o   open .bashrc and browser to available Blender verions." 
				   echo "-h   help text."
				;;
			esac
		done
fi


#~ case "$#" in
  #~ 0) 	echo "BlenderProg=[$BlenderProg]"
	#~ ;;
  #~ 1) 	case "$1" in
	#~ "-o") 	nautilus /opt/
		#~ gedit /home/kevin/.bashrc & 
		#~ ;;
	#~ *)	echo "Unknown parameter $1."
		#~ ;;
	#~ esac
	#~ ;;
  #~ *)	echo "$# Parameters."
	#~ for p in "$@"
	#~ do
		#~ echo "Parameter: $p"
	#~ done
	#~ ;;
#~ esac

echo "------------------------------------------------------------------------"
