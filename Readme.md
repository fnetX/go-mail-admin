# Go-Mail-Admin
HTTP interface with a small GUI for a mailserver based on the [Tutorial "Own mail server based on Dovecot, Postfix, MySQL, Rspamd and Debian 9 Stretch"](https://thomas-leister.de/en/mailserver-debian-stretch/).
The project will connect to the MYSQL database to read and write the config. 

You just need to download one binary file to the server and run it, no other dependencies. However, you may want to add an nginx with SSL in front of it, or make it only available via VPN.

The HTTP interface doesn't validate your data, it's just another way to access your database.
# Installation

Note: For installing the Go-Mail-Admin so it's always running and for adding it to the autostart there is a [step by step howto](https://github.com/kekskurse/go-mail-admin/blob/master/docs/install.md).

Download the last binary from the [Release Page](https://github.com/kekskurse/go-mail-admin/releases) to your Ubuntu/Debian mailserver. 

Set the environment variables to configure the Go-Mail-Admin, e.g.:
```
export GOMAILADMIN_DB="vmail:vmailpassword@tcp(127.0.0.1:3306)/vmail"
export GOMAILADMIN_APIKEY=abc
export GOMAILADMIN_APISECRET=abc
export GOMAILADMIN_PORT=3001
```

Then you can start the Go-Mail-Admin with the following command
```
./go-mail-admin-with-gui-<VERSION>
```

After that you can open the gui via http at http://servername:3001 (or your specified custom port)

# Usage
## Config
The script can be configured with environment variables. The following settings are possible:

| Key | Required | Default | Notice |
| --- | ---      | --- |   --- |
| GOMAILADMIN_DB | Yes | | Database connection string like 'username:password@tcp(127.0.0.1:3306)/database' |
| GOMAILADMIN_APIKEY | No | | API Key for HTTP-Basic-Auth (just use if APISECRET  is set too)  |
| GOMAILADMIN_APISECRET | No | | API Secret for HTTP-Basic-Auth (just use if APIKEY is set too) |
| GOMAILADMIN_ADDRESS | No | ":" (all) | IP address to bind to |
| GOMAILADMIN_PORT | No | 3001 | Port at which is bound (default: 3001) |
| GOMAILADMIN_CATCHALL | No | Off | If set to "On" the catchall feature will be enabled, its necessary that source_username in alias can be NULL |

## API

All features avalible in the Frontend are also in the API. The API current works with HTTP Basic Auth. [The documenation is avalible here](https://mrin9.github.io/OpenAPI-Viewer/#/load/https%3A%2F%2Fraw.githubusercontent.com%2Fkekskurse%2Fgo-mail-admin%2Fmaster%2Fdocs%2Fopenapi.json).


## Frontend
There is a VueJS frontend you can use to see and configure your mailserver. You can access it by opening http://yourmailserver.de:3001, if you set an API key and secret you need to performe a HTTP Basic Auth.

### Screenshots
*Dashboard*
![Dashboard](statik/dashboard.png)
*Domain List*
![Domainlist](statik/domains.png)
*Aliases*
![Domainlist](statik/aliases.png)
*Aliases Edit*
![Domainlist](statik/aliases-edit.png)
*Accounts*
![Domainlist](statik/accounts.png)
*Accounts Edit*
![Domainlist](statik/account-edit.png)
*TLS Policy*
![Domainlist](statik/tlspolicy.png)
*TLS Policy Edit*
![Domainlist](statik/tlspolicy-edit.png)
