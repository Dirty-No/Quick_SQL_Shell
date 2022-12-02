# Butterfly
FROM python

RUN apt update && apt install postgresql-client mariadb-client sqlite3 -yqq 
RUN pip install butterfly

CMD tail -f /dev/null