function mit_lectures {

while true ; do 
set_terminal ; echo -e "
########################################################################################
$cyan
                         MIT Lecture Series 2018
$orange
    This is a great lecture series for improving your understanding of how Bitcoin
    works - not for the beginner. It wasn't until I watched this that I felt I truly
    understood many concepts, including Segwit.

    The link to the website is:
   $green 
    https://ocw.mit.edu/courses/mas-s62-cryptocurrency-engineering-and-design-spring-2018/video_galleries/lecture-videos/
$orange
    One day this might be taken down so I have also included a torrent to my own
    copies which you can download yourself and seed to others using torrent software
    like qbittorrent (can download this with Parmanode).
$green
                   d)    Copy the torrent to your Desktop
$orange
########################################################################################
"
choose "xpmq"
read choice
case $choice in
q|Q) quit 0 ;; p|P) return 1 ;; M|m) back2main ;;
d)
cp $HOME/parman_programs/parmanode/src/education/MIT_lectures.torrent $HOME/Desktop/
announce "MIT_lectures.torrent has been copied to your Desktop"
break
;;
*) invalid ;;
esac
done

}