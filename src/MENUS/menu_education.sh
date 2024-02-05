function menu_education {

while true ; do
set_terminal
echo -e "
########################################################################################
 
$cyan
                            P A R M A N O D E - Education
$orange
                    
                    (mit)      2018 MIT Lecture Series (With Tagde Dryja)

                    (w)        How to connect your wallet to the node

                    (mm)       Bitcoin Mentorship Info

                    (n)        Six reasons to run a node

                    (s)        Seperation of money and state

                    (cs)       Cool stuff

            .... more soon


########################################################################################
"
choose "xpmq" ; read choice

case $choice in

m|M) back2main ;;
    mit)
        mit_lectures
        ;;

    w|W)
        connect_wallet_info
        ;;
    mm|MM|mM|Mm)
        mentorship
        ;;
    n|N|node|Node)
        # the less function inside the custom less_function takes a variable to know which file to print.
        less_function "6rn"
        ;;
    s|S)
        less_function "joinus"
        ;;
    cs|CS|Cs)
        cool_stuff
        ;;

    p|P) menu_use ;; 

    q|Q|Quit|QUIT)
        exit 0
        ;;
    *)
        invalid 
        ;;

esac
done
return 0
}

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
;;
*) invalid ;;
esac
done

}