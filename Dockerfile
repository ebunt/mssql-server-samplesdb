FROM mcr.microsoft.com/mssql/server:2019-CTP2.5-ubuntu
EXPOSE 1433

LABEL  "MAINTAINER" "Enrique Catalá Bañuls <ecatala@solidq.com>"
LABEL "Project" "SolidQ Summit Session - Planes de Ejecucion con SQL Server 2019"


RUN apt-get update && apt-get install -y  \
	curl \
	apt-transport-https

RUN mkdir -p /var/opt/mssql/backup
WORKDIR /var/opt/mssql/backup

##############################################################
# DATABASES SECTION
#    1) Add here the databases you want to have in your image
#    2) Edit setup.sql and include the RESTORE commands
#

# Adventureworks databases
#
RUN curl -L -o AdventureWorks2017.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak
RUN curl -L -o AdventureWorks2016.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2016.bak
RUN curl -L -o AdventureWorks2014.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2014.bak
RUN curl -L -o AdventureWorks2012.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2012.bak

RUN curl -L -o AdventureWorksDW2017.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2017.bak

# WideWorldImporters databases
#
RUN curl -L -o WideWorldImportersDW-Full.bak https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImportersDW-Full.bak
RUN curl -L -o WideWorldImporters-Full.bak https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

# Tpcc, Pubs and Northwind
#
COPY ./Backups/Pubs.bak ./
COPY ./Backups/Northwind.bak ./

##############################################################

RUN mkdir -p /usr/config
WORKDIR /usr/config/

COPY setup.* ./
COPY entrypoint.sh ./

RUN chmod +x setup.sh
RUN chmod +x entrypoint.sh

# This entrypoint start sql server, restores data and waits infinitely
#CMD /bin/bash ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

CMD ["sleep infinity"]