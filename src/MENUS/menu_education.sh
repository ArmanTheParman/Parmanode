function menu_education {

while true ; do
set_terminal
echo -ne "
########################################################################################$cyan

                            P A R M A N O D E - Educação $orange

########################################################################################

$cyan                    
                    (mit)$orange      Série de conferências do MIT de 2018 (com Tagde Dryja)
$cyan
                    (w)$orange        Como ligar a sua carteira ao seu nó
$cyan
                    (mm)$orange       Informações sobre o Bitcoin Mentorship
$cyan
                    (n)$orange        Seis razões para gerir um nó (ensaio)
$cyan
                    (s)$orange        Separação do dinheiro e do Estado (ensaio)
$cyan
                    (cs)$orange       Coisas fixes ("Sabia que?")


########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

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

    *)
        invalid 
        ;;

esac
done
return 0
}
