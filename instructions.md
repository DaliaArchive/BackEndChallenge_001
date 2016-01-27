#Robot daycare APIs:

##Notes

For the purpose of the exercise I used a rails 4 application with the default test database sqlite.

The application consists of a controller ( /controllers/api/robot_controller.rb) and three models : Robot, Revision, and Feature.

Robot  model has a one to many relationship with Revision and Revision has a one to many relationship with Feature.

Robot and Revision models have also convenience methods that are used to format the Json output of the API

The Revision model keeps track of the date of an update and the type of the update("create" or "update") and provide a gateway to access to all the features introduced with that update.

The Feature model represent every single feature that is submitted for a Robot and consist of a name-value pairs of attributes.

Every time  an update request for a Robot is issued, the application create a Revision entry. Then it creates a new Feature entry for every submitted parameter, and associate those features with the current revision. In this way is possible to keep track of every change in the existing features without overriding the values.

The application is configured to accept only Json requests and responds in Json format.

I decided to use RSpec as test suite and the specific tests for the APIs can be found inside
/spec/requests/api/robots_spec.rb


# How to run

### Run the application

* bundle install
* bundle exec rails s

### Run the tests

* bundle exec rspec (to run all the specs)


#Usage

##Update a robot's attributes

Update a robot's parameters, if the robot doesn't exit create a new one with the given parameters

`PUT /api/robots/[robot name]?[attribute]=[value]`

###Example:

  `PUT /api/robots/XX1?color=red`

Create the robot and set the parameter Red
```
  Return -->

  {
    "color": "red"
  }
```
Second call the robot exists

  `PUT /api/robots/XX1?color=white`

Update the color parameter for the existing robot
```
    Return -->

  {
    "color": "white"
  }
```

#Get a robot's actual attributes

Get all current attributes for a given robot's name in Json format

`GET /api/robots/[robot name]`

###Example:


```
GET /api/robots/XX1

Return -->

{
    "color": "red"
}
```
#Get a list of all the robot's in our database

Return a list of all the robots in the database with the last revision

`GET /api/robots`

###Example
```
GET /api/robots

Return -->

[
    {
        "name": "XX1",
        "last_update": "2016-01-26 09:40:26"
    },
    {
        "name": "XX2",
        "last_update": "2016-01-26 11:10:41"
    }
]
```

#Get a robot's attributes changes

Return a list of the robot attribute's changes over time

`GET /api/robots/[robot name]/history`

###Example:
```
GET /api/robots/[robot name]/history

Return -->

[
    {
        "2016-01-26 09:45:55": {
            "type": "create",
            "changes": [
                "color: [] -> [blue]"
            ]
        }
    },
    {
        "2016-01-26 10:57:47": {
            "type": "update",
            "changes": [
                "color: [blue] -> [red]"
            ]
        }
    },
]
```