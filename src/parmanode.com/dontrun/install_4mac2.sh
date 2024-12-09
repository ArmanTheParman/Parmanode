return 0
########################################################################################
# This is the install script kept at
# https://parmanode.com/install_4mac2.sh - the URL is easier to remember and shorter 
# than if keeping it on Github.


########################################################################################
#!/bin/sh

if [ -d $HOME/parman_programs/parmanode ] ; then
clear
#update parmanode if it exists...
if ! git config --global user.email ; then git config --global user.email sample@parmanode.com ; fi
if ! git config --global user.name ; then git config --global user.name Parman ; fi
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >$dn 2>&1

#make desktop text document...
if [ ! -e $HOME/Desktop/run_parmanode.txt ] ; then

touch $HOME/.zshrc >$dn 2>&1

if ! grep -q "run_parmanode.sh" $HOME/.zshrc ; then
echo "#Added by Parmanode...
function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh \$@ ; }
" | sudo tee -a $HOME/.zshrc >$dn 2>&1
fi

cat > $HOME/Desktop/run_parmanode.txt << 'EOF'
Para executar o Parmanode, basta abrir o terminal e digitar:

rp
e <enter>

'rp' significa 'run Parmanode'. Em alternativa, pode escrever manualmente a 
função 'rp'...

cd $HOME/parman_programs/parmanode/
<enter>
./run_parmanode.sh
<enter>

NOTA: o rp não funcionará na janela que usou para instalar o Parmanode. 
Feche-a, abra uma nova, e então o rp funcionará.

Pode apagar este ficheiro depois de ter absorvido a informação.
EOF
clear
echo "Ver novo documento de texto no ambiente de trabalho."
fi

#no further changes needed.
echo "Parmnode já descarregado."
exit
fi

########################################################################################
#Check mac version 10.9 or later...

export MacOSVersion=$(sw_vers | grep ProductVersion | awk '{print $ 2}')
export MacOSVersion_major=$(sw_vers | grep ProductVersion | cut -d \. -f 1 | grep -Eo '[0-9]+$')
export MacOSVersion_minor=$(sw_vers | grep ProductVersion | cut -d \. -f 2)
export MacOSVersion_patch=$(sw_vers | grep ProductVersion | cut -d \. -f 3)

if [[ ($MacOSVersion_major -lt 10) || ($MacOSVersion_major == 10 && $MacOSVersion_major -lt 9) ]] ; then
clear
echo "
########################################################################################

    Lamentamos, mas é necessário o MacOS versão 10.9 ou posterior para utilizar o Parmanode.

########################################################################################
    Prima <enter> para continuar.
"
read
exit 0
fi

while true ; do #loop 1
if xcode-select -p >$dn 2>&1 ; then break ; fi

#Install cldts
clear
sudo -k
echo "
########################################################################################
   
   É necessário o Command Line Developer Tools.

   Surgirá uma pergunta à qual terá de responder (pode estar minimizada, por isso veja a 
   barra de tarefas abaixo se não a vir). A estimativa de instalação indicará 
   inicialmente algumas HORAS, mas ignore isso, está errado.

   Depois de as ferramentas de linha de comando terem sido instaladas com êxito, 
   introduza a palavra-passe do computador e, em seguida, <enter> para continuar.

   Carregue em <enter> APENAS depois de o pop-up ter terminado a instalação, e não antes, 
   ou o computador irá derreter.
 
   Se quiser abandonar, pode premir <control> c agora.

####################################################################################### 
"
xcode-select --install

sudo sleep 0.1break
done #ends loop 1

########################################################################################
#Installing Parmanode

mkdir -p $HOME/parman_programs >$dn 2>&1 
cd $HOME/parman_programs
git clone https://github.com/armantheparman/parmanode.git

if ! grep -q "run_parmanode.sh" $HOME/.zshrc ; then
echo "#Added by Parmanode...
function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh \$@ ; }
" | sudo tee -a $HOME/.zshrc >$dn 2>&1
fi

#make desktop clickable icon...
cat > $HOME/Desktop/run_parmanode.txt << 'EOF'
Para executar o Parmanode, basta abrir uma nova janela do Terminal e digitar:

rp
e <enter>

'rp' significa 'run Parmanode'. Em alternativa, pode escrever manualmente a 
função 'rp'...

cd $HOME/parman_programs/parmanode/
<enter>
./run_parmanode.sh
<enter>

NOTA: o rp não funcionará na janela que utilizou para instalar o Parmanode.
Fecha-o, abre um NOVO e o rp funcionará.

Pode apagar este ficheiro depois de ter absorvido a informação.
EOF
clear

echo "#Added by Parmanode..." | tee -a $HOME/.zshrc >$dn 2>&1
echo 'function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh $@ ; }' | tee -a $HOME/.zshrc >$dn 2>&1

echo "
########################################################################################

    Deverá existir um ícone no ambiente de trabalho, \"run_parmanode.txt\", que é um 
    documento de texto que o recorda das seguintes instruções sobre como executar o Parmanode:

    Basta abrir uma nova janela do Terminal (feche esta primeiro) e digitar:

    rp
    e <enter>

    Divirta-se.

########################################################################################
"
exit
