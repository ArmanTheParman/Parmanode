if [[ $debug == 1 ]] ; then

echo "$macprefix" | tee -a $HOME/Desktop/report.txt

echo "$varlibtor" | tee -a $HOME/Desktop/report.txt

sudo cat $varlibtor/electrs-service/hostname | tee -a $HOME/Desktop/report.txt






fi