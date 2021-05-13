# docker-starbug1

starbug1(BTS) docker image.

## build ##

```
docker build -t starbug1 .
```

## run ##

```
docker run --rm --name starbug1 -p 8000:80 -d starbug1
```

URL: http://localhost:8000/

## stop ##

```
docker stop starbug1
```
