# Up and Running Test
[![Build Status](https://travis-ci.org/aboyon/upandrunningapp.svg?branch=master)](https://travis-ci.org/aboyon/upandrunningapp)
[![Maintainability](https://api.codeclimate.com/v1/badges/3fcca806fa42cc050387/maintainability)](https://codeclimate.com/github/aboyon/upandrunningapp/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3fcca806fa42cc050387/test_coverage)](https://codeclimate.com/github/aboyon/upandrunningapp/test_coverage)

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

For development:
```
docker-compose run upandrunning_web bundle exec rake db:create db:migrate
```
For testing (Rspec)
```
docker-compose run upandrunning_web bundle exec rake db:create db:migrate RAILS_ENV=test
```
And then, run the specs:
```
docker-compose run upandrunning_web bundle exec rspec spec
```

## Start the container

```
docker-compose up
```

## Accessing the app

- **Locally**: It's enough to visit [http://0.0.0.0:3000](http://0.0.0.0:3000).
- [Live demo](https://upandrunningfileuploader.herokuapp.com/files).
- How to get JSON responses?: add the `.json` to listing URL in order to get a JSON response. (e.g: https://upandrunningfileuploader.herokuapp.com/files.json or https://upandrunningfileuploader.herokuapp.com/files/+house%20/1.json)

## Miscellaneous

- **Time tracking**: This app took around ~12hs of development. It includes: Setting up the container, create the github repo, kick off the rails app, and make the tweaks required to fulfill with the requirements.
- **Pending improvements**: Ability to update a file. Ability to download the original attachment. Expose an API endpoint like http://0.0.0.0:3000/api/v1/files
- **Issue with ActiveStorage and Heroku**. Although [it is a known issue](https://devcenter.heroku.com/articles/active-storage-on-heroku), I'd like to do a mention about it. Free Dynos in heroku are restarted daily. It means that transient data (such as the files stored through ActiveStorage) is considered as disposable and it's erased on every restart. So might lead to unexpected behaviors in the [Live demo](https://upandrunningfileuploader.herokuapp.com/files) website.
