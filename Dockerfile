# Butterfly
FROM python

RUN apt update && apt install postgresql-client mariadb-client sqlite3 sudo -yqq 
RUN pip install butterfly

RUN useradd -ms /bin/bash sqlite

CMD tail -f /dev/null
