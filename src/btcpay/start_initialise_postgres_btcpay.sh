function  initialise_postgres_btcpay {
# start postgress, create parman database user with script, create 2 databases.

start_postgres_btcpay_indocker

postgres_database_creation || return 1
}

function start_postgres_btcpay_indocker {
docker exec -d -u root btcpay /bin/bash -c "service postgresql start" ||  announce "failed to start postgres database in docker"
}


function postgres_database_creation {

rm /tmp/postgres* 2>/dev/null
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
set_terminal ; echo "

    Some computers are slow.
    Parmanode will try 45 times with a 2 second pause for each try to give slow
    computers a chance to build the databases necessary for BTCPay to work.
    For most computers, the job should be done in under 5 seconds.
    You may quit at any time wit control-c.

    Counter is up to $counter
    
    "
sleep 2
done

log "btcpay" "failed to start btcpay database"
set_terminal
echo -e "Docker was unable to start the btcpay postgress database. Installation has$red failed$orange."
enter_continue
return 1
}


function postgres_database_creation_commands {
log "btcpay" "in postgres_database_creation"
sleep 1
docker exec -itu postgres btcpay /bin/bash -c "/home/parman/parmanode/postgres_script.sh" >/dev/null 2>&1
sleep 2
docker exec -itu postgres btcpay /bin/bash -c "createdb -O parman btcpayserver && createdb -O parman nbxplorer" >/dev/null 2>&1
debug "after postgres script and database creation"
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
