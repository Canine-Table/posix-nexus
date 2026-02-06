

nx_fpg_avi2mp4()
{
	ffmpeg -i "$1.avi" -c:v libx264 -c:a aac "$1.mp4"
}

