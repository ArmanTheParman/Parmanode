#need to carefully check this. There is a bug related to the if statements
# the subsequent cat files need checking.


function change_string_mac {
#will replace entire line containing search string with the new line
inputfile="$1"
searchstring="$2"
newline="$3"
positionnewline="$4" #("before" or "after" or "swap" or "delte")

if [[ $positionnewline == "after" ]] ; then
    sudo grep -m1 -B 1000000 ${searchstring} ${inputfile} > /tmp/temp1.txt
    echo $newline | tee -a /tmp/temp1.txt >/dev/null

    sudo grep -A 100000 ${searchstring} ${inputfile} > /tmp/temp2.txt 
    if [[ $count == 1 || $count == 0 ]] ; then
        cat /tmp/temp2.txt > /tmp/temp3.txt
    else
    count=$(wc -l /tmp/temp2.txt | awk '{print $1}')
    fi
    tail -n $(($count -1)) /tmp/temp2.txt > /tmp/temp3.txt

    sudo cat /tmp/temp1.txt /tmp/temp3.txt | sudo tee $inputfile >/dev/null
    debug "hi after"
fi


if [[ $positionnewline == "before" ]] ; then
    sudo grep -m1 -B 1000000 ${searchstring} ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')
    if [[ $count == 1 || $count == 0 ]] ; then
        cat /tmp/temp1.txt > /tmp/temp2.txt
    else
        head -n $(($count - 1 )) /tmp/temp1.txt > /tmp/temp2.txt
    fi
    echo $newline | tee -a /tmp/temp2.txt >/dev/null
    sudo grep -A 100000 ${searchstring} ${inputfile} >> /tmp/temp2.txt 
    sudo cat /tmp/temp2.txt | sudo tee $inputfile >/dev/null
    debug "hi before"
fi

if [[ $positionnewline == "swap" ]] ; then
    sudo grep -m1 -B 1000000 ${searchstring} ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')
    if [[ $count == 1 || $count == 0 ]] ; then
        cat /tmp/temp1.txt > /tmp/temp2.txt
    else
        head -n $(($count - 1 )) /tmp/temp1.txt > /tmp/temp2.txt
    fi
    echo $newline | tee -a /tmp/temp2.txt >/dev/null 

    sudo grep -A 100000 ${searchstring} ${inputfile} > /tmp/temp3.txt 
    count=$(wc -l /tmp/temp3.txt | awk '{print $1}')
    tail -n $(($count -1 )) /tmp/temp3.txt > /tmp/temp4.txt

    sudo cat /tmp/temp2.txt /tmp/temp4.txt | sudo tee $inputfile >/dev/null
    debug "hi swap"
fi

if [[ $positionnewline == "delete" ]] ; then
    sudo grep -m1 -B 100000 ${searchstring} ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')
    if [[ $count == 1 || $count == 0 ]] ; then
        cat /tmp/temp1.txt > /tmp/temp2.txt
    else
        head -n $(( $count - 1 )) /tmp/temp1.txt > /tmp/temp2.txt
    fi

    sudo grep -A 100000 ${searchstring} ${inputfile} > /tmp/temp3.txt 
    count=$(wc -l /tmp/temp3.txt | awk '{print $1}')
    tail -n $(($count - 1)) /tmp/temp3.txt > /tmp/temp4.txt

    sudo cat /tmp/temp2.txt /tmp/temp4.txt | sudo tee $inputfile >/dev/null
    debug "hi delete"
fi

cd /tmp >/dev/null
rm temp1.txt temp2.txt temp3.txt temp4.txt >/dev/null 2>&1
cd - >/dev/null
}
