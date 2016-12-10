FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential nodejs
RUN mkdir /backend_challenge_001
WORKDIR /backend_challenge_001
ADD Gemfile /backend_challenge_001/Gemfile
ADD Gemfile.lock /backend_challenge_001/Gemfile.lock
RUN bundle install
ADD . /backend_challenge_001
