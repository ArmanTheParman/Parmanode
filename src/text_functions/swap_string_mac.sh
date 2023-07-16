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
    count=$(wc -l /tmp/temp2.txt | awk '{print $1}')
    tail -n $(($count -1)) /tmp/temp2.txt > /tmp/temp3.txt

    cat /tmp/temp1.txt /tmp/temp3.txt > $inputfile
fi


if [[ $positionnewline == "before" ]] ; then
    sudo grep -m1 -B 1000000 ${searchstring} ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')
    head -n $(($count - 1)) /tmp/temp1.txt > /tmp/temp2.txt
    echo $newline | tee -a /tmp/temp2.txt >/dev/null
    sudo grep -A 100000 ${searchstring} ${inputfile} >> /tmp/temp2.txt 
    cat /tmp/temp2.txt > $inputfile
fi

if [[ $positionnewline == "swap" ]] ; then
    sudo grep -m1 -B 1000000 ${searchstring} ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')
    head -n $(($count - 1)) /tmp/temp1.txt > /tmp/temp2.txt
    echo $newline | tee -a /tmp/temp2.txt >/dev/null

    sudo grep -A 100000 ${searchstring} ${inputfile} > /tmp/temp3.txt 
    count=$(wc -l /tmp/temp3.txt | awk '{print $1}')
    tail -n $(($count -1)) /tmp/temp3.txt > /tmp/temp4.txt

    cat /tmp/temp2.txt /tmp/temp4.txt > $inputfile
fi

if [[ $positionnewline == "delete" ]] ; then
    sudo grep -m1 -B 1000000 ${searchstring} ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')
    head -n $(($count - 1)) /tmp/temp1.txt > /tmp/temp2.txt

    sudo grep -A 100000 ${searchstring} ${inputfile} > /tmp/temp3.txt 
    count=$(wc -l /tmp/temp3.txt | awk '{print $1}')
    tail -n $(($count - 1)) /tmp/temp3.txt > /tmp/temp4.txt

    cat /tmp/temp2.txt /tmp/temp4.txt > $inputfile
fi

cd /tmp >/dev/null
rm temp1.txt temp2.txt temp3.txt >/dev/null 2>&1
cd - >/dev/null
}
