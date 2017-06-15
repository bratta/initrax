# README

## <a name="about"></a>Initrax Initiative Tracker

*Initrax* is a simple, web-based iniative tracker for pen-and-paper role-playing games.
It was written initially to support [Pathfinder](http://paizo.com/pathfinderRPG) but
can be used by any d20 system utilizing initiative rolls, tracking hit
points, and so on. If your system is compatible with the DnD 3.5 ruleset
you should be good to go.

## Table of Contents

- [About](#about)
  * [Key Features](#features)
    + [Philosophy](#philosophy)
    + [User Access](#access)
    + [Application Capabilities](#capabilities)
  * [Using Initrax](#using)
  * [Hacker Central](#hacker-central)
    + [Self-Installation](#self-installation)
    + [Steps to Install via Docker](#docker)
    + [Steps to Install Manually](#manual)
  * [Contributing to Initrax](#contributing)
    + [Issues](#issues)
    + [Testing](#testing)
  * [License](#license)

## <a name="features"></a>Key Features

### <a name="philosophy"></a>Philosophy

The goal of Initrax is to stay minimal and out of the way. Too many
features will just detract from the game and keep you bogged down, when
the goal of the application is solely intended to keep track of combat
turn order with minimal fuss.

### <a name="access"></a>User Access

Secured by SSL, user access is a simple registration with the optional
ability to use [multi-factor authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication) 
by way of an authenticator app like [Google Authenticator](https://support.google.com/accounts/answer/1066447?hl=en).

### <a name="capabilities"></a>Application Capabilities

You can do the following in Initrax:

* Define your player characters and non-player characters.
* Capture hit points, initiative bonus and level/challenge-rating.
* Determine whether the character should have their initiative
  calculated automatically or use a physical die roll.
* Create named combat sessions by choosing each character participating
  in the combat.
* Take notes and update current hit points during combat.
* Add new characters to existing battles.
* Re-order your characters and combat
* Persist everything to the database so you can pick up combat later.

## <a name="using"></a>Using Initrax

You can register an account by visiting https://initrax.night.coffee and
start your game today!

## <a name="hacker-central"></a>Hacker Central

### <a name="self-installation"></a>Self-Installation

Would you like to host your own copy of Initrax? Well, you are in luck!
You need a machine capable of running Docker, or the ability to install
and manage the necessary services yourself.

### <a name="docker"></a>Steps to Install via Docker

* Need a Docker VM? Digital Ocean provides droplets with Docker
  pre-installed.
* You also need `docker-compose` so download that if you don't already
  have it.
* Clone this repository into whatever location you like. I recommend
  setting up a user named `initrax` on your machine and cloning the
  repository somewhere in `~initrax`.

```
  $ cd ~initrax
  $ git clone https://github.com/bratta/initrax.git live
  $ cd live
  $ cp .env.production.sample .env.production
```

* Open `.env.production` in your favorite text editor and change the
  settings for `DOMAIN` and for `SMTP_*`. I recommend setting up an
  account with [Mailgun](https://www.mailgun.com/). This is only needed
  to send user-related confirmation emails.
* Run the following commands:

```
  $ docker-compose build
  $ docker-compose run --rm app rake:secret
  $ docker-compose run --rm app rake:secret
```

* Yes, the above command is run _twice_. There are two secret fields in
  `.env.production`, so take the output of the above commands and put
  them in as the values for `SECRET_KEY_BASE` and
`TWO_FACTOR_AUTH_SECRET`.
* Run the following:

```
  $ docker-compose run --rm app rake db:migrate
  $ docker-compose run --rm app rake assets:precompile
  $ docker-compose up -d
```

At this point, your application is up and running. However, you will
need to configure your webserver to point to port 3000 in order to
actually serve up the data. I use nginx, so below is an example set
of server blocks you could use, but feel free to use the web server
of your choice.

#### Example configuration for nginx:

```
  server {
    listen 80;
    server_name initrax.night.coffee;

    location / {
      rewrite ^ https://$server_name$request_uri? permanent;
    }
  }

  server {
    listen 443;
    server_name initrax.night.coffee;

    ssl on;
    ssl_protocols TLSv1.2;
    ssl_ciphers EECDH+AESGCM:EECDH+AES;
    ssl_ecdh_curve secp384r1;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;

    ssl_certificate /path/to/fullchain.pem;
    ssl_certificate_key /path/to/privkey.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    add_header Referrer-Policy "strict-origin";
    add_header X-Content-Type-Options "nosniff";

    root /home/initrax/live/public;

    location / {
      try_files $uri @proxy;
    }

    location @proxy {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto https;

      proxy_pass_header Server;

      proxy_pass http://localhost:3000;
      proxy_buffering off;
      proxy_redirect off;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;

      tcp_nodelay on;
    }
  }
```

#### Server Management

This repository contains a few handy scripts in the `scripts/` directory
that can help you manage your installation.

* `scripts/upgrade-initrax` is a simple shell script that will pull down
  the latest master or tagged release, and allow you to optionally
  migrate the database or precompile assets. See `./upgrade-initrax -h`
  for usage information.
* `scripts/backup-postgres` performs a simple backup of the database to
  a specified location. See `scripts/backup-postgres -h` for usage
  information.
* `scripts/crontab.example` shows what a sample crontab might look like.
  It starts the docker containers on reboot, schedules regular backups,
  and prunes backups older than 30 days.

### <a name="manual"></a>Steps to Install Manually

*TODO:* Currently we don't have manual instructions detailed like they
should be. It's a basic Rails application, so if you are familiar with
Rails this is fairly straight-forward to deploy. You will need the
following:

* Access to Ruby 2.4.1 via rvm or rbenv
* Postgresql
* A web server such as nginx
* Ability to proxy from the web server to the rails server OR to use
  something like Passenger, Unicorn, or Puma.
* A capfile for deployment; currently this is on the list of things to
  do, but since I normally deploy this with Docker it has been low
  priority.

## <a name="contributing"></a>Contributing to Initrax

### <a name="issues"></a>Issues
* For bugs or feature requests, [submit an issue](https://github.com/bratta/initrax/issues) via Github.
* If you would like to contribute code, please feel free to [send pull requests](https://github.com/bratta/initrax/pulls)
  for existing issues or features you would like to see. If
  they fit with the general philosophy of the application, don't break
  the app, and tests pass, they will likely be approved.

### <a name="testing"></a>Testing

TODO: Still working out details on testing this code. I know, bad dev! Bad!

## <a name="license"></a>License

The MIT License

Copyright 2017 Tim Gourley

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
