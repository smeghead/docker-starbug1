# docker-starbug1

starbug1(BTS) docker image.

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
