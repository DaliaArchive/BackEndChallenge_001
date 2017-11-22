# Robots' daycare center

## Description

Robots' daycare center provides Apis to manage Robots. It provides 4 different kind of APIs to list all robots, view details of a robot, make changes to a robot and view the history of changes done to a robot.
## Demo

A demo of the apis can be found hosted on Heroku: 
https://robots-daycare-centre.herokuapp.com/robots

## API Details

### Robots Listing:
Returns list of robots.
#### GET /robots
https://robots-daycare-centre.herokuapp.com/robots

### Robot Details:
Returns details of the robot for the given name if it exists, otherwise gives missing message.
#### GET /robots/[name]
https://robots-daycare-centre.herokuapp.com/robots/RobotThree

### Robot Create or Update:
Create robot for the given name if it doesn't already exist, otherwise updates it.
#### PUT /robots/[name]
{
  "robot": {
    "attribute_key": "attribute_value",
    "another_attribute_key": "another_attribute_value"
  }
}

curl -X PUT -H "Content-Type: application/json" -d '{"robot":{"framework":"Rails"}}' "https://robots-daycare-centre.herokuapp.com/robots/RailsRobot"


### Robot History:
Returns history of changes done to the robot for the given name if it exists, otherwise gives missing message.
#### GET /robots/[name]/history
https://robots-daycare-centre.herokuapp.com/robots/RobotThree/history

## Testing:
rails test

## Implementation
It's built using Rails 5 as an API only app and uses PostgreSQL as the database. Other option that was considered for the implemenation was a combination of Sinatra and Sequel ORM. The history of changes done to a robot is implemented using Audited gem.

## Roadmap
There is no authentication currently supported which is not good for Restful Apis. Using Knock library can be considered as a solution for authentication based on JSON Web Tokens. There is no pagination also which needs to be implmented.
