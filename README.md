# docker-starbug1

starbug1(Bug Tracking System) docker image.

[Starbug1](http://www.starbug1.com/)

Starbug1 is BTS(Bug Tracking System wikipedia:Bug tracking system). Starbug1 is faster than recently BTS. You can use as ITS(Issue Tracking System). Starbug1 runs Web server on Windows, Linux OS, FreeBSD, MacOSX as CGI. If you want to use on Windows, you can download windows binary version.

## pull ##

```
docker pull smeghead7/starbug1
```

## run ##

```
docker run --rm --name starbug1 -v $(pwd)/db:/var/www/html/db -p 8000:80 -d smeghead7/starbug1
```

db is a directory contains databases.

URL: http://localhost:8000/

## stop ##

```
docker stop starbug1
```
