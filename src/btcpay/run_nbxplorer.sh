function run_nbxplorer {

docker exec -d -u parman btcpay /bin/bash -c "/home/parman/parmanode/NBXplorer/run.sh >/home/parman/parmanode/nbx.log" 

#"/usr/bin/dotnet \"/home/parman/parmanode/NBXplorer/NBXplorer/bin/Release/net6.0/NBXplorer.dll >/home/parman/parmanode/nbx.log\" -c \\
#/home/parman/.nbxplorer/Main/settings.config" \
}    