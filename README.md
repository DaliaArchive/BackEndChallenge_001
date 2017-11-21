Development environment setup
=============================

On OS X:

1. Install [Homebrew](https://brew.sh)
1. `brew install git`
1. Install Ruby 2.4.1 ([rbenv](https://github.com/rbenv/rbenv#installation) recommended)
1. `brew install postgres`
1. `initdb /usr/local/var/postgres -E utf8`
1. Clone this Git repository
1. `cd BackEndChallenge_001`
1. `rbenv local 2.4.1` (if using rbenv)
1. `gem install bundler`
1. `bundle install`
1. `gem install foreman`
1. `foreman start postgres_dev &` (starts postgres in the background temporarily to run rake db:setup)
1. `foreman run bundle exec rake db:setup`
1. `foreman start`
1. [http://localhost:5000/](http://localhost:5000/)

Running tests
=============

1. `bundle exec rake spec`

Trying the API
==============

In `bin/curl_examples.sh` are some basic, example requests.
You can run this file itself, or build other requests using it as a skeleton.
