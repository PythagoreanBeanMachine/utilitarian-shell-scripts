clear

echo "What is the name of the album: "
read album
echo "What is the name of the artist: "
read artist
echo "How many songs are on the album: "
read numTracks
echo "What is the genre: "
read genre
echo "What year was the album made: "
read year
echo "Do you have an album cover URL (Y/N)? "
#read art
#if [ art == "Y" || art == "y" ]; then
#	echo 'Enter the URL: '
#	read  url
#fi


#Get track names

for i in `seq 1 $numTracks`;
do
	#((trackNum=$i-1))
	echo "Enter the title of track $i: "
	read title
	Titles[$i]="$title"
done

base='/home/$USER/Music/'
slash='/'

if [ ! -d "$base$artist$slash$album" ]; then
	if [ ! -d "$base$artist" ]; then
		mkdir "$base$artist"
	fi
	
	if [ ! -d "$base$artist$slash$album" ]; then
		mkdir "$base$artist$slash$album"
	fi
fi

cd "$base$artist$slash$album"

# begin ripping the cd

cdparanoia -Bf

# convert to .flac versions

count=1

for i in $(ls); do
	ffmpeg -i $i track${count}.flac
	((count++))
done

# move .flac to flac directory

mkdir flac
mv *.flac flac
rm *.aiff
cd flac


# download album art

# wget $url



# tag each track

count=0
for i in `seq 1 $numTracks`;
do
	lltag --yes -t "${Titles[$i]}" -a "$artist" -A "$album" -g "$genre" -d "$year" -n "$i" --flac track${i}.flac
	metaflac --import-picture-from="$artPath"
	mv -v track${i}.flac "${Titles[$i]}".flac
done

clear

echo '--------------Files---------------'

ls *.flac

echo '--------------Files---------------'

eject /dev/sr0
