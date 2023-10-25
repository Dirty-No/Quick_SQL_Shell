# Butterfly
FROM python

# Install necessary packages
RUN apt update && apt install postgresql-client mariadb-client sqlite3 sudo unzip libaio1 rlwrap -yqq 
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

# Copy the init script into the image
COPY init.sh /usr/local/bin/init.sh

# Make the script executable
RUN chmod +x /usr/local/bin/init.sh

# Set the init script as the default command to run
CMD ["/usr/local/bin/init.sh"]
