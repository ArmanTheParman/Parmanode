function  initialise_postgres_btcpay {
# start postgres, create parman database user with script, create 2 databases.

start_postgres_btcpay_indocker

postgres_database_creation || return 1
}

function start_postgres_btcpay_indocker {
docker exec -d -u root btcpay /bin/bash -c "service postgresql start" 
}

function postgres_database_creation {

rm $tmp/postgres* 2>$dn
set_terminal

counter=0
while [[ $counter -le 45 ]] ; do
postgres_database_creation_commands

#check if database created before prceeding.

#get container to write to a log file the status of the database. Log is in a mounted volume
#accessible by host.
debug "wait here"

if docker exec -itu postgres btcpay /bin/bash -c "psql -l --no-psqlrc -P pager=off" | grep -q btcpayserver ; then
return 0
fi

counter=$((counter + 1))
set_terminal ; echo -e "

    Some computers are slow, or may be busy multitasking.
    Parmanode will try 45 times with a 2 second pause for each try to give slow
    computers a chance to build the databases necessary for BTCPay to work.
    For most computers, the job should be done in under 5 seconds.
    You may quit at any time wit control-c.

    Counter is up to $counter
    
    "
sleep 2
done

set_terminal
echo -e "Docker was unable to start the btcpay postgres database. Installation has$red failed$orange."
enter_continue
return 1
}


function postgres_database_creation_commands {
sleep 1
create_btcpay_parman_user
debug "check parman user has login permission before dabases are created"
sleep 2
if [[ $BTCPAYRESTORE == "true" ]] ; then
restore_btcpay
debug "after restore btcpay"
else
docker exec -itu postgres btcpay /bin/bash -c "createdb -O parman btcpayserver && createdb -O parman nbxplorer" >$dn 2>&1
fi
}




# config file: /etc/postgresql/13/main/pg_hba.conf 

#docker exec -d -u root btcpay /bin/bash -c \
#"echo \"
#local   all             postgres                                peer
#local   all             all                                     peer
#host    all             all             127.0.0.1/32            trust
#host    all             all             ::1/128                 trust
#local   replication     all                                     peer
#host    replication     all             127.0.0.1/32            md5
#host    replication     all             ::1/128                 md5
#" | tee /etc/postgresql/*/main/pg_hba.conf >/dev/null"

#docker exec -d -u root btcpay /bin/bash -c \
#"sed -i 's/md5/trust/g' /etc/postgresql/*/main/pg_hba.conf" 


function create_btcpay_parman_user {

docker exec -itu postgres btcpay bash -c "
for conf in /etc/postgresql/*/main/pg_hba.conf; do
  sed -i '1i host    all             parman          127.0.0.1/32            md5' \$conf
done >/dev/null 2>&1
"

docker exec -itu postgres btcpay bash -c "psql -U postgres -c \"
CREATE ROLE parman
WITH
  LOGIN
  PASSWORD 'NietShitcoin'
  CREATEDB
  NOSUPERUSER
  NOCREATEROLE;
\"
"
}

#docker exec -itu postgres btcpay bash -c "psql -U postgres -c \"DROP ROLE parman;\""
#sudo nano /etc/postgresql/15/main/pg_hba.conf
