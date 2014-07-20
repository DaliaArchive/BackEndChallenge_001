# Robolandia

Robolandia is a JSON API for "The robot's daycare center". It is built on top of sinatra and the only format supported is JSON.

It is very easy to extend the API by supporting other format's.

## Note

Robolandia uses basic access authentication (Basic HTTP Auth). User and pass can be found in the file auth.yml.
Basic HTTP Auth has some problems (plain text over the wire) and it wouldn't be used in a real production application but other mechanisms such as OAuth seems overkill for an API and for the purpose of the challenge.

## Installation

### Setting Up PostgreSQL - Ubuntu 13.04

Robolandia uses PostgreSQL for data persistence. A new feature in PostgreSQL 9.2 is JSON support. It includes a JSON data type and two JSON functions. This is very useful for a JSON API like Robolandia.

Since there isn't an official PostgreSQL repository for Ubuntu 13.04, a small work-around is needed:

sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common -t raring
sudo apt-get install postgresql-9.2 libpq-dev

## Configuration

### Database

The file database.yml has all the configuration needed for the production and test environments. 

sudo -u postgres createuser robolandia
sudo -u postgres psql
postgres=# \password robolandia

Run the migrations:

RACK_ENV=production bundle exec rake db:migrate
RACK_ENV=test bundle exec rake db:migrate

### Dependencies

To install all the dependencies just do a `bundle install`.

## Testing with RSpec

bundle exec rspec

## Running Robolandia in production environment

rackup config.ru

## Curl examples

### Create a robot with id 1

curl --request PUT 'http://localhost:9292/robots/1.json' --data '{ "first_name": "Bart", "last_name": "Simpson"}' --header 'Content-Type:application/json' -u inspector:'g76F&h8'

### Get a specific robot by id 

curl --request GET 'http://localhost:9292/robots/1.json' -u inspector:'g76F&h8'

### Change attributes of existent robot 

curl --request PUT 'http://localhost:9292/robots/1.json' --data '{ "last_name": "Barney", "age": "25" }' --header 'Content-Type:application/json' -u inspector:'g76F&h8'

### Get robot history

curl --request GET 'http://localhost:9292/robots/1/history.json' -u inspector:'g76F&h8'

### Get all available robots

curl --request GET 'http://localhost:9292/robots' -u inspector:'g76F&h8'


