# Up and Running Test

## Setting up the environment

Application runs in a Docker container using [Ruby 2.5](https://hub.docker.com/_/ruby/). You can find more information about installed packages looking at the [Dockerfile](Dockerfile).

## Building the environment

```
docker-compose build
```
It will take a while _(as we need to download some packages and install them)_. You can verify if building suceeded by searching an output like this:
```
Step 10/11 : EXPOSE 3000
 ---> Using cache
 ---> cb5516ec371d
Step 11/11 : CMD ["bash"]
 ---> Using cache
 ---> 4e969b2b24bc
Successfully built 4e969b2b24bc
Successfully tagged upandrunning_worker:latest
```

## Verifiying Docker images

Just run `docker images` at your project path. The expected output may look like:
```
REPOSITORY                          TAG                   IMAGE ID            CREATED             SIZE
upandrunning_upandrunning_web       latest                4e969b2b24bc        5 seconds ago       1.12GB
upandrunning_worker                 latest                4e969b2b24bc        5 seconds ago       1.12GB
```

## Setting up the app

At this point, you already have built your container and have your images in place, ready to be used. So. next step is to setup the databases and start the application.

### Setting up database

```
docker-compose run upandrunning_web bundle exec rake db:create
```
Expected output:
```
➜  upandrunning git:(master) ✗ docker-compose run upandrunning_web bundle exec rake db:create
Starting upandrunning_db_1_edb561a21f81    ... done
Starting upandrunning_redis_1_5f21833da705 ... done
Created database 'upandrunning_development'
Created database 'upandrunning_test'
```

## Start the container

```
docker-compose up
```

## Accessing the app

It's enough to visit [http://0.0.0.0:3000](http://0.0.0.0:3000).
