# DrRoboto

**DrRoboto** is a small Sinatra API for an imaginary robots treatment center. 

The **API Docs** can be found here: [http://docs.drroboto.apiary.io/](http://docs.drroboto.apiary.io/).

## Installation

### Configuration

The configs for running and testing **DrRoboto** in **development** mode can be 
found and change in ``.env.development`` and ``.env.test``.

When running in **production**, all the values in your ``.env`` file should 
be set to proper *environment* variables (like in ``.bashrc`` or something).

### Standalone & Testing

1. Clone the repository at ``git@github.com:lipanski/BackEndChallenge_001.git``.
2. Create the databases and user credentials from your ``.env`` files.
3. Run the migrations:
```bash
RACK_ENV=development bundle exec rake db:migrate
RACK_ENV=test bundle exec rake db:migrate
```
4. You can now run the test suite:
```bash
bundle exec rspec
```
5. Or run a server:
```bash
bundle exec rackup
```
6. Or use ``rerun`` to update the server every time you change something to the code:
```bash
bundle exec rerun rackup
```

### As a rack middleware

Include the gem in your Gemfile:
```ruby
gem 'dr_roboto', :git => 'git://github.com/lipanski/BackEndChallenge_001'
```

Run ``bundle install`` and edit your ``routes.rb`` file, by adding the following:
```ruby
mount DrRoboto::App => '/api'
```
