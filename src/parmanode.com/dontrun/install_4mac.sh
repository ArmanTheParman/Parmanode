return 0
# not live


########################################################################################
# This is the install script kept at
# https://parmanode.com/install_4mac.sh - the URL is easier to remember and shorter 
# than if keeping it on Github.

########################################################################################
#!/bin/sh

printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 

if [ -d $HOME/parman_programs/parmanode ] ; then
clear
#update parmanode if it exists...
if ! git config --global user.email ; then git config --global user.email sample@parmanode.com ; fi
if ! git config --global user.name ; then git config --global user.name Parman ; fi
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >$dn 2>&1

#make desktop clickable icon...
if [ ! -e $HOME/Desktop/run_parmanode.sh ] ; then
cat > $HOME/Desktop/run_parmanode.sh << 'EOF'
#!/bin/bash
cd $HOME/parman_programs/parmanode/
./run_parmanode.sh
EOF
sudo chmod +x $HOME/Desktop/run_parmanode*
echo "Criação de um novo ícone clicável no ambiente de trabalho."
fi

#no further changes needed.
echo "Parmnode já descarregado."
exit
fi

#Assuming not previously installed parmanode...

    if ! which git ; then 

        if ! which brew >$dn ; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
        if ! which brew >$dn ; then export warning=1 ; fi
        fi

        if ! which ssh >$dn ; then 
            if [ $warning = 1 ] ; then echo "problema com o homebrew, precisava de instalar o git. Abortando." ; sleep 4 ; exit ; fi
            brew install ssh 
        fi

        if ! which gpg >$dn ; then 
            if [ $warning = 1 ] ; then echo "problema com o homebrew, precisava de instalar o git. Abortando." ; sleep 4 ; exit ; fi
            brew install gpg 
        fi

        brew install git
    fi

#####################################################################################################

# Parmanode first time install most likely...

sudo -k
if [[ ! -e /Library/Developer/CommandLineTools ]] ; then git --version ; fi 
clear
echo "
########################################################################################
    
    Certifique-se de que todas as solicitações pop-up para instalar ferramentas de 
    desenvolvedor foram concluídas antes de continuar aqui.

########################################################################################
"
sudo sleep 0.1

mkdir -p $HOME/parman_programs >$dn 2>&1 
cd $HOME/parman_programs
git clone https://github.com/armantheparman/parmanode.git

#make desktop clickable icon...
cat > $HOME/Desktop/run_parmanode.sh << 'EOF'
#!/bin/bash
cd $HOME/parman_programs/parmanode/
./run_parmanode.sh
EOF
sudo chmod +x $HOME/Desktop/run_parmanode.sh >$dn 2>&1
clear
echo "
########################################################################################

    Deverá aparecer um ícone no ambiente de trabalho, \"run_parmanode.sh\".

    Se fizer duplo clique e o seu Mac estiver configurado para abrir um editor de texto 
    em vez de executar o programa, isso pode ser ultrapassado escrevendo isto no terminal:


            $HOME/parman_programs_parmanode/run_parmanode.sh

    É sensível a maiúsculas e minúsculas.

########################################################################################
"
exit
