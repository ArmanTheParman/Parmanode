# function make_postgres_database {

USER postgres
RUN service postgresql start && \
    psql --command "CREATE USER parman_BTCP WITH PASSWORD 'parmanode' CREATEDB;" && \
    service postgresql stop

RUN PASSWORD=parmanode service postgresql start && \
    createdb -O parman_BTCP btcpayserver -h localhost -U parman_BTCP && \
    createdb -O parman_BTCP nbxplorer -h localhost -U parman_BTCP && \
    service postgresql stop




}