# MailSlurper Alpine

![mailsluper](https://img.shields.io/badge/mailslurper%20version-1.14.1-blue)
![image](https://img.shields.io/docker/v/lakuapik/mailslurper-alpine?label=docker%20image%20version&sort=semver)
![size](https://img.shields.io/docker/image-size/lakuapik/mailslurper-alpine?sort=semver&label=docker%20image%20size)
![pulls](https://img.shields.io/docker/pulls/lakuapik/mailslurper-alpine)

> MailSlurper is a small SMTP mail server that slurps mail into oblivion! MailSlurper is perfect for individual developers or small teams writing mail-enabled applications that wish to test email functionality without the risk or hassle of installing and configuring a full blown email server. It's simple to use! Simply setup MailSlurper, configure your code and/or application server to send mail through the address where MailSlurper is running, and start sending emails! MailSlurper will capture those emails into a database for you to view at your leisure.

This is an alpine build for [MailSlurper](https://github.com/mailslurper/mailslurper).

## Usage

### Configuration

Example of `config.json` file

```json
{
    "wwwAddress": "0.0.0.0",
    "wwwPort": 8080,
    "wwwPublicURL": "",
    "serviceAddress": "0.0.0.0",
    "servicePort": 8085,
    "servicePublicURL": "",
    "smtpAddress": "0.0.0.0",
    "smtpPort": 2500,
    "dbEngine": "SQLite",
    "dbHost": "",
    "dbPort": 0,
    "dbDatabase": "./mailslurper.db",
    "dbUserName": "",
    "dbPassword": "",
    "maxWorkers": 1000,
    "autoStartBrowser": false,
    "keyFile": "",
    "certFile": "",
    "adminKeyFile": "",
    "adminCertFile": ""
}
```

Please refer to [MailSlurper Wiki](https://github.com/mailslurper/mailslurper/wiki).

### Running the image

```sh
# run and let go
$ docker run -p 2500:2500 -p 8080:8080 -p 8085:8085 --rm lakuapik/mailslurper-alpine

# or with custom config
$ docker run \
-v $PWD/config.json:/mailslurper/config.json \
-p 2500:2500 -p 8080:8080 -p 8085:8085 \
lakuapik/mailslurper-alpine
```

### Using docker-compose

```yml
version: "3"
services:
    # ....
    mailslurper: # for mail catcher
        image: lakuapik/mailslurper-alpine:latest
        ports:
            - "${FORWARD_MAILSLURPER_PUBLIC_PORT:-8080}:8080"
            - "${FORWARD_MAILSLURPER_SERVICE_PORT:-8085}:8085"
            - "${FORWARD_MAILSLURPER_SMTP_PORT:-2500}:2500"
        network_mode: bridge
        healthcheck:
            test: [
                "CMD", "wget", "-nv", "-t1", "--spider",
                "http://localhost:${FORWARD_MAILSLURPER_PUBLIC_PORT:-8080}"
            ]
    # ....
```

## Credit

Thanks to:
- https://github.com/mailslurper/mailslurper/
- https://github.com/mpas/docker-mailslurper
