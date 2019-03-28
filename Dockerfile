FROM ruby:2.5

MAINTAINER Up and Running DevOps <jdsilveira@gmail.com>

# this way we can source the profile
RUN rm /bin/sh && ln -s /bin/bash /bin/sh\
  && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections\
  && apt-get update\
  && apt-get -y install build-essential patch ruby-dev zlib1g-dev liblzma-dev pkg-config libxml2-dev libxslt-dev libpq-dev postgresql-client git libcurl4-openssl-dev gnupg2 --force-yes\
  && curl -sL https://deb.nodesource.com/setup_8.x | bash -\
  && apt-get install -y nodejs\
  && rm -rf /var/lib/apt/lists/*

WORKDIR /upandrunning
RUN gem install bundler:1.17.2
COPY Gemfile /upandrunning/Gemfile
COPY Gemfile.lock /upandrunning/Gemfile.lock
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install
EXPOSE 3000
CMD ["bash"]
