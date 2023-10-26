#not taken into account multiple entries of a searchstring.
#delete function will remove multiple entries, so be careful #to use it in other parts of this function.

function change_string_mac {
# will replace entire line containing search string with the new line
# Some fancy options created with "positionnewline", the fourth argument 
# to help with adding a line before or after a search item
# Useful for modifying configuration files of apps without disturbing syntax or structure.
debug2 "change string mac:
inpute file: $1
search string: $2
newline: $3
positionnewline: $4
"
inputfile="$1"
searchstring="$2"
newline="$3"
positionnewline="$4" #("before" or "after" or "swap" or "delete")

if [[ ! -f $inputfile ]] ; then # if file doesn't exist
return 1
fi
if ! grep -q "$searchstring" < "$inputfile" ; then
debug2 "no $searchstring in inputfile: $inputfile "
log "error" "searchstring, $searchstring, doesnt exist, using change_sting_mac for file $inputfile"
return 0
fi

    # if [[ $debug == 1 && $(grep $searchstring $inputfile | wc -l | awk '{print $1}') > 1 ]] ; then
    # echo "Warning. More than 1 instance of search term found. Aborting." ; return 0 
    # fi

if [[ "$positionnewline" == "after" ]] ; then
    sudo grep -m1 -B 100000 "${searchstring}" ${inputfile} > /tmp/temp1.txt
    echo $newline | tee -a /tmp/temp1.txt >/dev/null
    #new line is added after seaerchstring
    sudo grep -A 100000 "${searchstring}" ${inputfile} > /tmp/temp2.txt 
    count=$(wc -l /tmp/temp2.txt | awk '{print $1}')
    if [[ $count == 1 ]] ; then 
    #condition where there's nothing to add because nothing comes after the searchstring
        cat /tmp/temp1.txt | sudo tee $inputfile >/dev/null
        #file done
    else
        tail -n $(($count -1)) /tmp/temp2.txt >> /tmp/temp1.txt
        cat /tmp/temp1.txt | sudo tee $inputfile >/dev/null
        #file done
    fi
fi

#working
if [[ "$positionnewline" == "before" ]] ; then
    sudo grep -m1 -B 1000000 "${searchstring}" ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')

    if [[ $count == 1 ]] ; then
        echo "$newline" > /tmp/temp2.txt
        cat /tmp/temp2.txt /tmp/temp1.txt > $inputfile    
        #file done 

    else
        head -n $(($count - 1 )) /tmp/temp1.txt > /tmp/temp2.txt
        echo "$newline" | tee -a /tmp/temp2.txt >/dev/null
        sudo grep -A 100000 "${searchstring}" ${inputfile} | sudo tee -a /tmp/temp2.txt >/dev/null
        cat /tmp/temp2.txt | sudo tee $inputfile >/dev/null
        #file done
    fi
fi

#working ok now
if [[ "$positionnewline" == "swap" ]] ; then
    sudo grep -m1 -B 100000 "${searchstring}" ${inputfile} > /tmp/temp1.txt
    count=$(wc -l /tmp/temp1.txt | awk '{print $1}')

    if [ $count == 1 ] ; then # means searchstring is on line one of input file.
        #need to delete first line of inputfile and replace with newline...
        count_inputfile=$(wc -l $inputfile | awk '{print $1}')
        sudo tail -n $(($count_inputfile -1)) $inputfile | tee /tmp/temp2.txt >/dev/null
        #temp2 holds inputfile without first line now
        echo "$newline" | tee /tmp/temp3.txt >/dev/null
        cat /tmp/temp3.txt /tmp/temp2.txt | sudo tee $inputfile >/dev/null
        #file done
    else
        #temp1 has n number of other lines then searchstring last.
        #need to delete last line of temp1
        count_temp1=$(wc -l /tmp/temp1.txt | awk '{print $1}')
        head -n $(( $count_temp1 - 1 )) /tmp/temp1.txt | tee /tmp/temp2.txt >/dev/null
        #now append $newline to temp2
        echo "$newline" | tee -a /tmp/temp2.txt >/dev/null
        #now add bottom part of inputfile to temp2
        sudo grep -A 100000 "${searchstring}" ${inputfile} | tee /tmp/temp3.txt >/dev/null
            #delete line one of temp3
            count_temp3=$(wc -l /tmp/temp3.txt | awk '{print $1}')
            tail -n $(( $count_temp3 - 1 )) /tmp/temp3.txt | tee /tmp/temp4.txt >/dev/null
            #temp4 holds bottom part needed from inputfile

        #now append temp4 to temp 2 to make inputfile final.
        cat /tmp/temp2.txt /tmp/temp4.txt | sudo tee $inputfile >/dev/null
        #file done
    fi
fi
#this part works
if [[ "$positionnewline" == "delete" ]] ; then
    
    sudo grep -v "$searchstring" $inputfile | tee /tmp/temp1.txt >/dev/null
    cat /tmp/temp1.txt | sudo tee $inputfile >/dev/null
fi

cd /tmp 
rm temp1.txt temp2.txt temp3.txt temp4.txt >/dev/null 2>&1
cd $original_dir 
}