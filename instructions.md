#Robot daycare APIs:

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

Get a robot's attributes changes

Return a list of the robot attribute's changes over time

`GET /api/robots/[robot name]/history`

Example:
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