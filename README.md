
# OnlineSQL
Quickly get a MySQL/Postgres/SQLite web shell for testing purposes.

## Deploy:

    docker compose up

nginx will listen on http://localhost:8888/ by default.

You will be able to access the following routes:
- /mysql
- /postgres
- /sqlite

You can configure anything you need by editing docker-compose.yml and proxy/templates/default.conf


### TODO:
- Network and system sandboxing. 
	- (Right now this is an entry point to your network, use with approriate security measures)
