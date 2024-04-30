FROM python

# Install necessary packages
RUN apt update && apt install postgresql-client mariadb-client sqlite3 sudo unzip libaio1 rlwrap -yqq

# Install Microsoft SQL Server command line tools
# Import the public repository GPG keys
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Register the Microsoft SQL Server Ubuntu repository
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install SQL Server command line tools
RUN apt update && ACCEPT_EULA=Y apt install -yqq msodbcsql17 mssql-tools unixodbc-dev

# Make SQLCMD globally accessible
ENV PATH=$PATH:/opt/mssql-tools/bin

# Install Butterfly
RUN pip install butterfly

# Add a new user for SQLite
RUN useradd -ms /bin/bash sqlite

# Download and install Oracle Instant Client and SQL*Plus
RUN mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    curl -O https://download.oracle.com/otn_software/linux/instantclient/19600/instantclient-basiclite-linux.x64-19.6.0.0.0dbru.zip && \
    curl -O https://download.oracle.com/otn_software/linux/instantclient/19600/instantclient-sqlplus-linux.x64-19.6.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-19.6.0.0.0dbru.zip && \
    unzip instantclient-sqlplus-linux.x64-19.6.0.0.0dbru.zip && \
    rm -f instantclient-basiclite-linux.x64-19.6.0.0.0dbru.zip instantclient-sqlplus-linux.x64-19.6.0.0.0dbru.zip && \
    echo /opt/oracle/instantclient_19_6 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

# Update PATH to include Oracle Instant Client/SQL*Plus
ENV PATH=$PATH:/opt/oracle/instantclient_19_6



# Setup db2 shell
ADD https://github.com/scgray/jsqsh/releases/download/jsqsh-2.3/jsqsh-2.3-noarch.deb /tmp/jsqsh.deb
RUN apt install -yqq /tmp/jsqsh.deb && rm /tmp/jsqsh.deb
# Skip jsqsh setup
RUN mkdir -p ~/.jsqsh && touch ~/.jsqsh/.welcome


ADD https://repo1.maven.org/maven2/com/ibm/db2/jcc/db2jcc/db2jcc4/db2jcc-db2jcc4.jar /opt/db2/
ENV CLASSPATH=$CLASSPATH:/opt/db2/db2jcc-db2jcc4.jar


# Copy the init script into the image
COPY init.sh /usr/local/bin/init.sh

# Make the script executable
RUN chmod +x /usr/local/bin/init.sh

# Set the init script as the default command to run
CMD ["/usr/local/bin/init.sh"]
