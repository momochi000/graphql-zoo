FROM docker.io/ruby:3.3-slim
RUN apt-get update
RUN apt-get -yy install build-essential git

RUN mkdir /app
WORKDIR /app

COPY ./zoo/Gemfile .
COPY ./zoo/Gemfile.lock .

RUN bundle install

COPY ./zoo/ .
