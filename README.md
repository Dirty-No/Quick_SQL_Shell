
# OnlineSQL
Quickly get a MySQL/Postgres/SQLite web shell for testing purposes.

## Deploy:

    docker compose up

nginx will listen on http://localhost:8888/ by default.

You will be able to access the following routes:
- /mysql
- /postgres
- /oracle
- /sqlite
- /mssql
- /db2

You can configure anything you need by editing docker-compose.yml and proxy/templates/default.conf

## Security:
Containers are sandboxed using dedicated users and an isolated network, but as a security measure, you should probably not directly expose this on the internet.

