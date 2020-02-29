# Go-Mail-Admin
HTTP interface with a small GUI for a mailserver based on the [Tutorial "Own mail server based on Dovecot, Postfix, MySQL, Rspamd and Debian 9 Stretch"](https://thomas-leister.de/en/mailserver-debian-stretch/).
The project will connect to the MYSQL database to read and write the config. 

You just need to download one binary file to the server and run it, no other dependencies. However, you may want to add an nginx with SSL in front of it, or only make it available via VPN.

The HTTP interface doesn't validate your data, it's just another way to access your database.
# Installation

Note: For installing the Go-Mail-Admin so it's always running and for adding it to the autostart there is a [step by step howto](https://github.com/kekskurse/go-mail-admin/blob/master/install.md).

Download the last binary from the [Release Page](https://github.com/kekskurse/go-mail-admin/releases) to your Ubuntu/Debian mailserver. 

Set the environment variables to configure the Go-Mail-Admin
```
export GOMAILADMIN_DB="vmail:vmailpassword@tcp(127.0.0.1:3306)/vmail"
export GOMAILADMIN_APIKEY=abc
export GOMAILADMIN_APISECRET=abc
```

Then you can start the Go-Mail-Admin with the following command:
```
./go-mail-admin-with-gui-<VERSION>
```

After that you can open the GUI via http at http://servername:3001

# Usage
## Config
The script can be configurated with environment variables. The following settings are possible:

| Key | Required | Notice |
| --- | ---      | --- |
| GOMAILADMIN_DB | Yes | Database connection string like 'username:password@tcp(127.0.0.1:3306)/database' |
| GOMAILADMIN_APIKEY | No | API Key for HTTP-Basic-Auth (just use if APISECRET  is set too)  |
| GOMAILADMIN_APISECRET | No | API Secret for HTTP-Basic-Auth (just use if APIKEY is set too) |

## API
### Domains
Domain Action can be triggered by an HTTP call to /api/v1/domain. Parameter can be transmitted as JSON body:

```
{
  "id": 1,
  "domain": "example.com"
}
```

| Method | Notice |
| ---    | ---    |
| GET    | List all Domains |
| POST   | Create a new Domain, required Parameters: domain |
| DELETE | Delete a Domain, required Parameters: domain |

### Aliases
Alias actions can be triggered through an HTTP call to /api/v1/alias. Parameter can be transmitted as JSON body:

```
{
  "id": 2,
  "source_username": "admin",
  "source_domain": "example.com",
  "destination_username": "test",
  "destination_domain": "example.com",
  "enabled": true,
  "print_source": "admin@example.com", # Just to show it in a gui based on source_username@source_domain
  "print_destination": "test@example.com" # Just to show it in a gui based on destination_username@destination_domain
}
```

| Method | Notice |
| ---    | ---    |
| GET    | List all Aliases |
| POST   | Create a new Alias, required Parameters: source_username, source_domain, destination_username, destination_domain, enabled |
| DELETE | Delete a Domain, required Parameters: id |
| PUT    | Apdate a Alias, required Parameters: source_username, source_domain, destination_username, destination_domain, enabled, id |

### Account
Account actions can be triggered through a HTTP call to /api/v1/account. Parameter can be transmitted as JSON body:

```
{
  "id": 1,
  "username": "admin",
  "domain": "example.com",
  "quota": 3000,
  "enabled": true,
  "sendonly": false,
  "print": "admin@example.com" # Just to show it in a gui, based on username@domain
}
```

| Method | Notice |
| ---    | ---    |
| GET    | List all Accounts |
| POST   | Create a new Account, required Parameters: username, domain, password, quota, enabled, sendonly |
| DELETE | Delete a Account, required Parameters: id |
| PUT    | Apdate a Alias, required Parameters: quota, enabled, sendonly, id |

To update the password, make an HTTP call to /api/v1/account/password with the Json body parameter: id, password

### TLSpolicies
TLS policies can be changed through an HTTP call to /api/v1/tlspolicy

```
{
  "id": 1,
  "domain": "example.com",
  "policy": "dane",
  "params": "match=*.example.com"
}
```

| Method | Notice |
| ---    | ---    |
| GET    | List all Policys |
| POST   | Create a new Policy, required Parameters: domain, policy, params |
| DELETE | Delete a Policy, required Parameters: id |
| PUT    | Apdate a Policy, required Parameters: domain, policy, params, id |

## Frontend
There is a VueJS frontend you can use to see and configure your mailserver. You can access it by opening http://yourmailserver.de:3001. If you set an API key and secret you need to performe a HTTP Basic Auth.

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

# Dev
## Project structure
In the folder "mailserver-configurator-interface" you'll find the GO project which provides an HTTP API for the mailserver config. The "mailserver-configurator-client" is a VUEJS interface for that HTTP API.

## Compile
### Mailserver-Configurator-Client
Open the project folder and build the Vue.js project

```
npm install
npm run build
```
### Mailserver-Configurator-Interface
Open the project folder. Make sure all dependencies are there:

```
go get github.com/go-sql-driver/mysql
go get github.com/go-chi/cors
go get gopkg.in/unrolled/render.v1
go get github.com/go-chi/chi
go get github.com/rakyll/statik
```

Create a "public" folder and copy the dist folder from the client into it.

```
mkdir public
cd public
cp -r ../../mailserver-configurator-client/dist/* ./
cd ..
```

Copy the static files (Vue app) to GO to make it available in the binary.
```
statik -f -src=./public
```
or
```
~/go/bin/statik -f -src=./public
```
Then build the GO project
```
go build ./
```

In the build-with-gui.sh in the project root there's a shell script to build the client and interface. You can call it with a name:
```
./build-with-gui.sh dev
```
will create a go-mail-admin-with-gui-dev in the project root.
