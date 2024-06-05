function btcpay_compile_choice {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                    Build Choice
$orange
    Parmanode can either build the Docker image from source (from a Dockerfile), or it can
    pull (download) a pre-made image. Building it is slower but less trust involved. 

$cyan
                    1)$orange     Build it (slower)
$cyan
                    2)$orange     Just pull the image (faster)


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

xxx)

break
;;

*)
invalid
;;
esac
done

}