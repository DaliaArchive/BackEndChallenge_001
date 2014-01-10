#Robots Daycare, version 1

This JSON API has 4 methods - Update, Show, Index, History. 

Content Type - JSON only

Robots are configured to store attributes within an hstore data attribute. A sample Robot looks like:

{

- "id" : 1,
- "data" : {"name": "R2D2", "color" : "blue"},
- "created_at" :
- "updated_at" :

}

##Installation:

1. Fork the repo from https://github.com/smilansky/BackEndChallenge_001. 
2. Pull the code locally and then run bundle install.
3. Run rails server from the terminal.

####[Update] update a robot's attributes

To update a robot, make the following request:

  -url: http://localhost:3000/api/v1/robots/:id
  -Method: PATCH
  -Body : 

  {

  - "robot" : {"data" : {"attribute_1" : "200", "attribute_2" : "blue"}} 

  }

Be aware that the attributes are not predefined and can be anything on both sides: key and value.

####[Show] get a robot's actual attributes

To show the actual attributes of a robot, make the following request:

- url: http://localhost:3000/api/v1/robots/:id
- method: GET
- Body : N/A

####Example

The inspector asks for the robot XX1 and the system responses with the following information:

{

- "id" : 1,
- "data" : {"color":"blue","weight":"200"},
- "created_at" : "2014-01-09T18:56:10.000Z",
- "updated_at" : "2014-01-10T04:46:57.000Z"

}

####[Index] get a list of all the robot's in our database

To have an overview of all the robot's in our database, make the following request:

- url: http://localhost:3000/api/v1/robots/
- method: GET
- Body : N/A

####[History] get a robot's attributes changes

In order to obtain the history and evolution of attribute changes for a specific robot, make the following request:

- url: http://localhost:3000/api/v1/robots/:id/history
- method: GET
- Body : N/A

####Notes:

Authentication was not included since I wanted to make interaction with the API faster. I elected to use Rails-API since it is lightweight but provides structure for expansion should the API become more complex.

